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
#import "circular_buffer.hpp"

#define BUFFER_SIZE 44100
#define REPLAY_BUFFER_SIZE 512

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
    CCircularBuffer<float> replay_buffer;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        track = new CComposedTrack({CSignalFactory::kickDrum(32.70),
            CSignalFactory::snareDrum(),
            CSignalFactory::hihat_drum()});
//        track = new CComposedTrack({
//            CSignalFactory::bell_thingy(noteC2),
//            CSignalFactory::bell_thingy(noteCd2),
//            CSignalFactory::bell_thingy(noteD2),
//            CSignalFactory::bell_thingy(noteDd2),
//            CSignalFactory::bell_thingy(noteE2),
//            CSignalFactory::bell_thingy(noteF2),
//            CSignalFactory::bell_thingy(noteFd2),
//            CSignalFactory::bell_thingy(noteG2),
//            CSignalFactory::bell_thingy(noteGd2),
//            CSignalFactory::bell_thingy(noteA2),
//            CSignalFactory::bell_thingy(noteAd2),
//            CSignalFactory::bell_thingy(noteB2),
//            CSignalFactory::bell_thingy(noteC3),
//            CSignalFactory::bell_thingy(noteCd3),
//            CSignalFactory::bell_thingy(noteD3),
//            CSignalFactory::bell_thingy(noteDd3),
//            CSignalFactory::bell_thingy(noteE3),
//            CSignalFactory::bell_thingy(noteF3),
//            CSignalFactory::bell_thingy(noteFd3),
//            CSignalFactory::bell_thingy(noteG3),
//            CSignalFactory::bell_thingy(noteGd3),
//            CSignalFactory::bell_thingy(noteA3),
//            CSignalFactory::bell_thingy(noteAd3),
//            CSignalFactory::bell_thingy(noteB3)
//        });
        
        buffering_queue = dispatch_queue_create("com.file_reader.buffer_queue", DISPATCH_QUEUE_SERIAL);
        lock = [[NSLock alloc] init];
        readBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        writeBuffer = (float *)calloc(BUFFER_SIZE, sizeof(float));
        read_buffer_ready = false;
        buffer_position = 0;
        should_keep_playing = false;
        replay_buffer.alloc_size(REPLAY_BUFFER_SIZE);
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
    [self.delegate composedTrack:self didPrepareBuffer:writeBuffer];
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
//    [self clearBuffers];
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
            replay_buffer.write(0);
            replay_buffer.increase_start_index();
            return 0;
        }
    }
    float ret_val = readBuffer[buffer_position];
    buffer_position += 1;
    replay_buffer.write(ret_val);
    replay_buffer.increase_start_index();
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

- (void)toggleBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat length:(NSInteger)length drumId:(NSString *)drumId {
    [lock lock];
    track->toggle_signal((int)instrument, (int)beat, (int)length, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}

- (void)addBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat length:(NSInteger)length drumId:(NSString *)drumId {
    [lock lock];
    track->toggle_signal((int)instrument, (int)beat, (int)length, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}

- (void)removeBeatForInstrument:(NSInteger)instrument drumId:(NSString *)drumId {
    [lock lock];
    track->remove_signal((int)instrument, [drumId cStringUsingEncoding:NSUTF8StringEncoding]);
    [lock unlock];
}

- (const float *)replayValues {
    return replay_buffer.to_linear_buffer();
}

@end
