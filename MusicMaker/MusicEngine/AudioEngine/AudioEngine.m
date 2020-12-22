//
//  AudioEngine.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.12.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "AudioEngine.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioEngine()

@property (nonatomic, strong) AVAudioEngine *audioEngine;

@end


@implementation AudioEngine {
    float timeStamp;
}

- (double) sampleRate {
    return [[self.audioEngine.outputNode inputFormatForBus:0] sampleRate];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        timeStamp = 0;
        self.audioEngine = [[AVAudioEngine alloc] init];
        [self prepareEngine];
    }
    return self;
}

- (void)prepareEngine {
    AVAudioMixerNode *mainMixer = self.audioEngine.mainMixerNode;
    AVAudioOutputNode *output = self.audioEngine.outputNode;
    AVAudioFormat *outputFormat = [output inputFormatForBus: 0];
    AVAudioFormat *inputFormat = [[AVAudioFormat alloc] initWithCommonFormat:outputFormat.commonFormat
                                                                  sampleRate:outputFormat.sampleRate
                                                                    channels:1
                                                                 interleaved:outputFormat.isInterleaved];
    AVAudioSourceNode *sourceNode = [[AVAudioSourceNode alloc] initWithRenderBlock:^OSStatus(BOOL * _Nonnull isSilence, const AudioTimeStamp * _Nonnull timestamp, AVAudioFrameCount frameCount, AudioBufferList * _Nonnull outputData) {
        for (int i = 0; i < frameCount; ++i) {
            float value = [self.delegate audioEngineValueForNextFrame] / 5.0;
            float capped = MIN(1.0, MAX(-1.0, value));
            for (int j = 0; j < outputData->mNumberBuffers; ++j) {
                float *data = (float *)outputData->mBuffers[j].mData;
                data[i] = capped;
            }
        }
        return noErr;
    }];
    [self.audioEngine attachNode:sourceNode];
    [self.audioEngine connect:sourceNode to:mainMixer format: inputFormat];
    [self.audioEngine connect:mainMixer to: output format: outputFormat];
    mainMixer.outputVolume = 0.5;
}

- (void)play {
    NSError *error = nil;
    [self.audioEngine startAndReturnError:&error];
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)stop {
    [self.audioEngine stop];
}

@end
