//
//  ComposedTrack.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "ComposedTrack.h"
#import "composed_track.hpp"
#import "signal_factory.hpp"
#import "note.h"

#define BUFFER_SIZE 44100

@implementation ComposedTrack {
    CComposedTrack *track;
    NSLock * lock;
    dispatch_queue_t buffering_queue;
    float * readBuffer;
    float * writeBuffer;
    int32_t buffer_position;
    int32_t file_length;
    bool read_buffer_ready;
    bool write_buffer_ready;
    __strong NSData* audioData;
    bool should_keep_playing;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        track = new CComposedTrack(CSignalFactory::kickDrum(130.81),
//                                   CSignalFactory::snareDrum(),
//                                   CSignalFactory::hihat_drum(),
//                                   CSignalFactory::modulated_bass(noteA1, noteB1),
//                                   CSignalFactory::modulated_bass(noteB0, noteB0),
//                                   CSignalFactory::separate_reverb_chord(noteC5, noteEb5, noteG5),
//                                   CSignalFactory::separate_reverb_chord(noteF4, noteA4, noteC5),
//                                   CSignalFactory::separate_reverb_chord(noteG4, noteBb4, noteD5));
        track = new CComposedTrack({
            CSignalFactory::bell_thingy(noteC5),
            CSignalFactory::bell_thingy(noteCd5),
            CSignalFactory::bell_thingy(noteD5),
            CSignalFactory::bell_thingy(noteDd5),
            CSignalFactory::bell_thingy(noteE5),
            CSignalFactory::bell_thingy(noteF5),
            CSignalFactory::bell_thingy(noteFd5),
            CSignalFactory::bell_thingy(noteG5),
            CSignalFactory::bell_thingy(noteGd5),
            CSignalFactory::bell_thingy(noteA5),
            CSignalFactory::bell_thingy(noteAd5),
            CSignalFactory::bell_thingy(noteB5)
        });
        
        buffering_queue = dispatch_queue_create("com.file_reader.buffer_queue", DISPATCH_QUEUE_SERIAL);
        lock = [[NSLock alloc] init];
        readBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        writeBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        read_buffer_ready = false;
        buffer_position = 0;
        should_keep_playing = false;
    }
    return self;
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
    for (int i = 0; i < BUFFER_SIZE; ++i) {
        writeBuffer[i] = track->play_next_frame();
    }
    write_buffer_ready = true;
    [lock unlock];
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
    float *temp = readBuffer;
    readBuffer = writeBuffer;
    writeBuffer = temp;
    buffer_position = 0;
    read_buffer_ready = true;
    write_buffer_ready = false;
    [lock unlock];
//    [self notifyBufferChangeAsync];
}

- (void)dealloc {
    delete track;
    free(readBuffer);
    free(writeBuffer);
}

- (void)start {
    track->StartPlaying();
    should_keep_playing = true;
    [self prepareSwappingBuffer];
    [self swapBuffers];
    [self prepareSwappingBufferAsync];
}

- (void)stop {
    track->StopPlaying();
}

- (float)next_sample {    
    if (buffer_position >= BUFFER_SIZE) {
        if (write_buffer_ready) {
            [self swapBuffers];
            if (should_keep_playing) {
                [self prepareSwappingBufferAsync];
            } else {
                [self clearBuffers];
            }
        } else {
            return 0;
        }
    }
    float ret_val = readBuffer[buffer_position];
    buffer_position += 1;
    return ret_val;
}

- (void)clearBuffers {
    [lock lock];
    for (int i = 0; i < BUFFER_SIZE; ++i) {
        readBuffer[i] = .0f;
        writeBuffer[i] = .0f;
    }
    read_buffer_ready = false;
    [lock unlock];
}

- (void)reset {
    
}

- (void)toggleBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat drumId:(NSString *)drumId {
    [lock lock];
    track->toggle_signal((int)instrument, (int)beat, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}

- (void)addBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat drumId:(NSString *)drumId {
    [lock lock];
    track->toggle_signal((int)instrument, (int)beat, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}

- (void)removeBeatForInstrument:(NSInteger)instrument drumId:(NSString *)drumId {
    [lock lock];
    track->remove_signal((int)instrument, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}


@end
