//
//  RecordedTrack.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "RecordedTrack.h"
#import "recorded_track.hpp"
#import "signal.hpp"
#import "signal_factory.hpp"
#import "waveform_signal.hpp"
#import "sine_wave.hpp"
#import "combined_signal.hpp"
#import <vector>
#import "AudioFileLoader.h"
#import "fft.hpp"
#import "pcm_signal.hpp"
#import "AudioFileReader.h"
#import <stdlib.h>
#import <limits.h>

#define WAVE_BUFFER_SIZE 256
#define MAX_BUFFER_SIZE 88200
#define SAMPLE_RATE 44100

@interface RecordedTrack() <AudioFileReaderDelegate>

@property (nonatomic, strong) AudioFileReader *audioFileReader;

@end

@implementation RecordedTrack {
    CRecordedTrack *track;
    CPCMSignal *signal;
    BOOL playing;
    
    SInt16 * wave_buffer;
    __strong NSData *wave_data;
    float * wave_fragment_data;
    float * frequency_fragment_data;
    NSLock *lock;
    unsigned long available_bytes;
    unsigned long wave_fragment_length;
    int offset;
    CFourierTransform *fft;
}

- (NSUInteger)wave_buffer_size {
    return wave_fragment_length;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        CSineWave *wave = new CSineWave(440, 1.0, 0.0);
//        CSineWave *wave2 = new CSineWave(3000, 1.0, 0.0);
//        CSignal *signal = new CWaveformSignal({ wave }, { 1.0 });
//        CSignal *signal2 = new CWaveformSignal({ wave2 }, { 1.0 });
//        CSignal *total = new CCombinedSignal({signal, signal2});
//        CSignal *total = CSignalFactory::kickDrum(175);
//        track = new CRecordedTrack(total, 1.0);
//        SInt32 size = 0;
//        SInt16 * bytes = [self loadFile:&size];
//        signal = new CPCMSignal(bytes, size);
        wave_buffer = (SInt16 *)malloc(WAVE_BUFFER_SIZE * sizeof(SInt16));
        wave_fragment_data = (float *)malloc(WAVE_BUFFER_SIZE * sizeof(float));
        frequency_fragment_data = (float *)malloc(WAVE_BUFFER_SIZE * sizeof(float));
        available_bytes = 0;
        playing = NO;
        self.audioFileReader = [[AudioFileReader alloc] init];
        self.audioFileReader.delegate = self;
        lock = [[NSLock alloc] init];
        fft = new CFourierTransform(256);
    }
    return self;
}

- (float *)get_points {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test_track" withExtension:@"mp3"];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    NSData *sound = [[[AudioFileLoader alloc] init] audioFileReaderWithData:audioData];
    SInt16 * samples = (SInt16 *)[sound bytes];
    float * fsamples = (float *)malloc(sizeof(float) * sound.length / 4);
    for (int i = 0; i < sound.length / 4; ++i) {
        fsamples[i] = (float)samples[i * 2] / float(32767);
    }
//
//    fft.fft(fsamples);
    return fsamples;
//    return track->get_array_points(44100);
}

- (int)get_points_count {
//    return track->get_number_of_samples(44100);
    return 44100;
}

- (float *)get_frequency_analysis {
    return track->get_frequency_analysis(44100, 1024);
}

- (SInt16 *)loadFile:(SInt32 *)size {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test_track" withExtension:@"mp3"];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    NSData *sound = [[[AudioFileLoader alloc] init] audioFileReaderWithData:audioData];
    SInt16 * samples = (SInt16 *)[sound bytes];
    SInt16 * mono_samples = (SInt16 *)malloc(sizeof(SInt16) * sound.length / 4);
    for (int i = 0; i < sound.length / 4; ++i) {
        mono_samples[i] = samples[i * 2];
    }
    *size = (SInt32)sound.length / 4;
    return mono_samples;
}

- (void)start {
//    signal->start();
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test_track" withExtension:@"mp3"];
    [self.audioFileReader prepareAudioFileFromURLAsync:url];
    playing = YES;
}

- (void)stop {
//    signal->stop();
    playing = NO;
}

- (float)next_sample {
    if (!playing) {
        return 0;
    }
    float retVal = [self.audioFileReader readNextValue];
    return retVal;
}

- (float *)wave_fragment {
    return wave_fragment_data;
}

- (float *)frequency_fragment {
    return frequency_fragment_data;
}

- (void)prepareWaveFragment {
    [lock lock];
    int byte_count = WAVE_BUFFER_SIZE;
    if (wave_data == nil) {
        [lock unlock];
        return;
    }
    if (available_bytes - offset < WAVE_BUFFER_SIZE) {
        [lock unlock];
        return;
    }
    int adjusted_count = fmin(byte_count, available_bytes - offset);
    wave_fragment_length = adjusted_count;
    SInt16 *form = (SInt16 *)[wave_data bytes];
    for (int i = 0; i < adjusted_count; ++i) {
        wave_fragment_data[i] = (float)form[offset + i * 2] / (float)(SHRT_MAX);
    }
    memcpy(frequency_fragment_data, wave_fragment_data, WAVE_BUFFER_SIZE * sizeof(float));
    fft->fft(frequency_fragment_data);
    offset += byte_count;
    [lock unlock];
}

- (void)audioFileReaderDidGetNewBuffer:(NSData *)data {
    [lock lock];
    wave_data = data;
    available_bytes = data.length / 4;
    offset = 0;
    [lock unlock];
    SInt16 * bytes = (SInt16 *)[data bytes];
    [self.delegate recordedTrackDidGetNewBuffer:bytes length:data.length / 4];
}

- (void)dealloc {
    free(wave_buffer);
    free(wave_fragment_data);
    free(frequency_fragment_data);
    delete fft;
}

@end
