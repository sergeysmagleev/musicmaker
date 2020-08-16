//
//  LiveTrack.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 05.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "LiveTrack.h"
#import <stdlib.h>
#import <vector>
#import "live_track.hpp"

#define BUFFER_SIZE 1024

@interface LiveTrack() {
    CLiveTrack *liveTrack;
    NSLock * lock;
    dispatch_queue_t buffering_queue;
    float * readBuffer;
    float * writeBuffer;
    int32_t buffer_position;
    int32_t file_length;
    bool read_buffer_ready;
    bool write_buffer_ready;
    __strong NSData* audioData;
}

@end

@implementation LiveTrack

- (instancetype)initWithSampleRate:(float)sampleRate {
    self = [super init];
    if (self) {
        liveTrack = new CLiveTrack(sampleRate);
        buffering_queue = dispatch_queue_create("com.file_reader.buffer_queue", DISPATCH_QUEUE_SERIAL);
        lock = [[NSLock alloc] init];
        readBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        writeBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        read_buffer_ready = false;
        buffer_position = BUFFER_SIZE;
        [self prepareSwappingBuffer];
    }
    return self;
}

- (float) advanceTimeAndReturnNextValue {
    return [self readNextValue];
}

- (void) addToneWithFrequency:(float)frequency lfoFrequency:(float)lfoFrequency isKick:(BOOL)isKick {
    liveTrack->addSignal(isKick, frequency);
}

- (void) addSignals {
    liveTrack->addSignals();
}

- (void) startPlayingNoteAtIndex:(int)index {
    liveTrack->startPlayingNote(index);
}

- (void) stopPlayingNoteAtIndex:(int)index {
    liveTrack->stopPlayingNote(index);
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
        writeBuffer[i] = liveTrack->advanceTimeAndReturnNextValue();
    }
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
    float ret_val = readBuffer[buffer_position];
    buffer_position += 1;
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
    delete liveTrack;
}

@end
