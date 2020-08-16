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
        track = new CComposedTrack(CSignalFactory::kickDrum(130.81),
                                   CSignalFactory::snareDrum(),
                                   CSignalFactory::hihat_drum(),
                                   CSignalFactory::modulated_bass(noteA1, noteB1),
                                   CSignalFactory::modulated_bass(noteB0, noteB0),
//                                   CSignalFactory::modulated_bass(55.00, 58.00),
//                                   CSignalFactory::separate_reverb_chord(659.25, 783.99, 987.77),
                                   
//                                   CSignalFactory::single_reverb_chord(130.81, 155.56, 196.00),
//                                   CSignalFactory::single_reverb_chord(87.31, 110.00, 130.81),
//                                   CSignalFactory::single_reverb_chord(98.00, 116.54, 146.83)
                                   
//                                   CSignalFactory::separate_reverb_chord(noteC6, noteEb6, noteG6),
//                                   CSignalFactory::separate_reverb_chord(noteF5, noteA5, noteC6),
//                                   CSignalFactory::separate_reverb_chord(noteG5, noteBb5, noteD6)
                                   
                                   CSignalFactory::separate_reverb_chord(noteC5, noteEb5, noteG5),
                                   CSignalFactory::separate_reverb_chord(noteF4, noteA4, noteC5),
                                   CSignalFactory::separate_reverb_chord(noteG4, noteBb4, noteD5)
                                   
//                                   CSignalFactory::separate_reverb_chord(noteC4, noteEb4, noteG4),
//                                   CSignalFactory::separate_reverb_chord(noteF3, noteA3, noteC4),
//                                   CSignalFactory::separate_reverb_chord(noteG3, noteBb3, noteD4)
                                   
//                                   CSignalFactory::separate_reverb_chord(noteC3, noteEb3, noteG3),
//                                   CSignalFactory::separate_reverb_chord(noteF2, noteA2, noteC3),
//                                   CSignalFactory::separate_reverb_chord(noteG2, noteBb2, noteD3)
                                   
//                                   CSignalFactory::separate_reverb_chord(2637.02, 3135.96, 3951.07)
                                   
//.G3 : 196.00,
//.Gd3 : 207.65,
//.Ab3 : 207.65,
//.A3 : 220.00,
//.Ad3 : 233.08,
//.Bb3 : 233.08,
//.B3 : 246.94,
//.C4 : 261.63,
//.Cd4 : 277.18,
//.Db4 : 277.18,
//.D4 : 293.66,
                                   
                                   );
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

@end
