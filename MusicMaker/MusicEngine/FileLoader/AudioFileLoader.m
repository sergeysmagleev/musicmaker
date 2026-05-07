//
//  AudioFileLoader.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 23.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "AudioFileLoader.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "FileUtil.h"

@implementation AudioFileLoader

-(NSData *) audioFileReaderWithData: (NSData *) audioData {
    AudioFileID refAudioFileID;
    ExtAudioFileRef inputFileID;
    
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
    
    // Client Audio Format Description
    AudioStreamBasicDescription clientFormat;
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
    result = ExtAudioFileSetProperty(inputFileID, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
    
    if (result != noErr) {
        NSLog(@"error on ExtAudioFileSetProperty for input File with result code %i \n", result);
    }
    size = sizeof(clientFormat);
    int totalFrames = 0;
    NSInteger frame = 0;
    NSMutableData *totalData = [[NSMutableData alloc] init];
    
    while (1) {
//        ExtAudioFileSeek(inputFileID, 2750000);
        UInt32 bufferByteSize = 22050 * 4 * 2;
        char srcBuffer[bufferByteSize];
        UInt32 numFrames = (bufferByteSize/clientFormat.mBytesPerFrame);
        
        AudioBufferList fillBufList;
        fillBufList.mNumberBuffers = 1;
        fillBufList.mBuffers[0].mNumberChannels = clientFormat.mChannelsPerFrame;
        fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
        fillBufList.mBuffers[0].mData = srcBuffer;
        result = 0;
//        result = AudioFileReadBytes(refAudioFileID, true, 0, &numFrames, <#void * _Nonnull outBuffer#>)
        result = ExtAudioFileRead(inputFileID, &numFrames, &fillBufList);
        
        if (result != noErr) {
            NSLog(@"Error on ExtAudioFileRead with result code %i \n", result);
            totalFrames = 0;
            break;
        }
        NSUInteger bytesRead = (NSUInteger)numFrames * clientFormat.mBytesPerFrame;
        NSData *data = [NSData dataWithBytes:fillBufList.mBuffers[0].mData
                                      length:bytesRead];
        [totalData appendData:data];
        if (numFrames == 0) {
            break;
        }
        totalFrames = totalFrames + numFrames;
    }
    
    //Clean up
    
    ExtAudioFileDispose(inputFileID);
    AudioFileClose(refAudioFileID);
    
    return totalData;
}

@end
