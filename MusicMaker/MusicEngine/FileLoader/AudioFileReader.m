//
//  AudioFileReader.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 25.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "AudioFileReader.h"
#import <AudioToolbox/AudioToolbox.h>
#import <limits.h>
#import "FileUtil.h"

#define BUFFER_SIZE 22050

@interface AudioFileReader()

@end

@implementation AudioFileReader {
    NSLock * lock;
    dispatch_queue_t buffering_queue;
    AudioFileID refAudioFileID;
    ExtAudioFileRef inputFileID;
    AudioStreamBasicDescription clientFormat;
    int16_t * readBuffer;
    int16_t * writeBuffer;
    int32_t buffer_position;
    int32_t file_position;
    int32_t file_length;
    bool read_buffer_ready;
    bool write_buffer_ready;
    __strong NSData* audioData;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        buffering_queue = dispatch_queue_create("com.file_reader.buffer_queue", DISPATCH_QUEUE_SERIAL);
        lock = [[NSLock alloc] init];
        readBuffer = (int16_t *)calloc(BUFFER_SIZE, sizeof(int16_t));
        writeBuffer = (int16_t *)calloc(BUFFER_SIZE, sizeof(int16_t));
        read_buffer_ready = false;
        file_position = 2000000;
        buffer_position = BUFFER_SIZE;
    }
    return self;
}

- (void)prepareAudioFileFromURLAsync:(NSURL *)url {
    dispatch_async(buffering_queue, ^{
        __weak typeof(self) wself = self;
        if (wself == NULL) {
            return;
        }
        __strong typeof(self) s = wself;
        [s prepareAudioFileFromURL:url];
    });
}

- (void)prepareAudioFileFromURL:(NSURL *)url {
    audioData = [NSData dataWithContentsOfURL:url];
    NSLog(@"size of compressed music data: %lu", (unsigned long)[audioData length]);
    OSStatus result = AudioFileOpenWithCallbacks((__bridge void * _Nonnull)((NSData *)audioData),
                                                 readProc,
                                                 0,
                                                 getSizeProc,
                                                 0,
                                                 kAudioFileMP3Type,
                                                 &refAudioFileID);
    if (result != noErr) {
        NSLog(@"problem in theAudioFileReaderWithData function: result code %i \n", result);
    }
    
    result = ExtAudioFileWrapAudioFileID(refAudioFileID,
                                         false,
                                         &inputFileID);
    if (result != noErr) {
        NSLog(@"problem in theAudioFileReaderWithData function Wraping the audio FileID: result code %i \n", result);
    }
    
    memset(&clientFormat, 0, sizeof(clientFormat));
    clientFormat.mFormatID = kAudioFormatLinearPCM;
    clientFormat.mFramesPerPacket = 1;
    clientFormat.mChannelsPerFrame = 2;
    clientFormat.mBitsPerChannel = 16;
    clientFormat.mBytesPerPacket = clientFormat.mBytesPerFrame = 2 * clientFormat.mChannelsPerFrame;
    clientFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian;
    clientFormat.mSampleRate = 44100;
    
    int size = sizeof(clientFormat);
    result = 0;
    result = ExtAudioFileSetProperty(inputFileID,
                                     kExtAudioFileProperty_ClientDataFormat,
                                     size,
                                     &clientFormat);
    if (result != noErr) {
        NSLog(@"error on ExtAudioFileSetProperty for input File with result code %i \n", result);
    }
    ExtAudioFileSeek(inputFileID, file_position);
    [self prepareSwappingBuffer];
    [self swapBuffers];
    [self prepareSwappingBuffer];
}

- (void)prepareSwappingBufferAsync {
    dispatch_async(buffering_queue, ^{
        __weak typeof(self) wself = self;
        if (wself == NULL) {
            return;
        }
        __strong typeof(self) s = wself;
        [s prepareSwappingBuffer];
    });
}

- (void)prepareSwappingBuffer {
    [lock lock];

    UInt32 bufferByteSize = 44100;
    UInt32 numFrames = (bufferByteSize / clientFormat.mBytesPerFrame);
    
    AudioBufferList fillBufList;
    fillBufList.mNumberBuffers = 1;
    fillBufList.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
    fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
    fillBufList.mBuffers[0].mData = writeBuffer;
    OSStatus result = 0;
    //        result = AudioFileReadBytes(refAudioFileID, true, 0, &numFrames, <#void * _Nonnull outBuffer#>)
    result = ExtAudioFileRead(inputFileID, &numFrames, &fillBufList);
    NSLog(@"read %d frames from file", numFrames);
    int32_t totalFrames = 0;
    if (result != noErr) {
        NSLog(@"Error on ExtAudioFileRead with result code %i \n", result);
        totalFrames = 0;
        [lock unlock];
        return;
    }
    if (!numFrames) {
        [lock unlock];
        return;
    }
    totalFrames = totalFrames + numFrames;
//    NSData *data = [[NSData alloc] initWithBytes:fillBufList.mBuffers[0].mData
//                                          length:fillBufList.mBuffers[0].mDataByteSize];
//    memcpy(writeBuffer, fillBufList.mBuffers[0].mData, fillBufList.mBuffers[0].mDataByteSize);
    file_position += BUFFER_SIZE / 2;
    write_buffer_ready = true;
    [lock unlock];
}

- (float)readNextValue {
    if (buffer_position >= BUFFER_SIZE) {
        if (write_buffer_ready) {
            [self swapBuffers];
            [self prepareSwappingBufferAsync];
        } else {
            return 0;
        }
    }
    float ret_val = (float)readBuffer[buffer_position] / (float)SHRT_MAX;
    buffer_position += 2;
    return ret_val;
}

- (void)swapBuffersAsync {
    dispatch_async(buffering_queue, ^{
        __weak typeof(self) wself = self;
        if (wself == NULL) {
            return;
        }
        __strong typeof(self) s = wself;
        [s swapBuffers];
    });
}

- (void)swapBuffers {
    [lock lock];
    int16_t *temp = readBuffer;
    readBuffer = writeBuffer;
    writeBuffer = temp;
    buffer_position = 0;
    read_buffer_ready = true;
    write_buffer_ready = false;
    [lock unlock];
    [self notifyBufferChangeAsync];
}

- (void)notifyBufferChangeAsync {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifyBufferChange];
    });
}

- (void)notifyBufferChange {
    NSData *bufferData = [[NSData alloc] initWithBytes:readBuffer length:BUFFER_SIZE];
    [self.delegate audioFileReaderDidGetNewBuffer:bufferData];
}

- (void)dealloc {
    free(writeBuffer);
    free(readBuffer);
    ExtAudioFileDispose(inputFileID);
    AudioFileClose(refAudioFileID);
}

@end
