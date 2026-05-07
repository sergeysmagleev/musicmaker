//
//  AudioEngine.m
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.12.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import "AudioEngine.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

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
    AVAudioFormat *hardwareFormat = [output inputFormatForBus: 0];
    AVAudioChannelCount channelCount = MAX((AVAudioChannelCount)1, hardwareFormat.channelCount);
    AVAudioFormat *inputFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32
                                                                  sampleRate:hardwareFormat.sampleRate
                                                                    channels:channelCount
                                                                 interleaved:NO];
    AVAudioSourceNode *sourceNode = [[AVAudioSourceNode alloc] initWithFormat:inputFormat renderBlock:^OSStatus(BOOL * _Nonnull isSilence, const AudioTimeStamp * _Nonnull timestamp, AVAudioFrameCount frameCount, AudioBufferList * _Nonnull outputData) {
        for (int i = 0; i < frameCount; ++i) {
            float value = [self.delegate audioEngineValueForNextFrame];
            float capped = MIN(1.0, MAX(-1.0, value));
            for (int j = 0; j < outputData->mNumberBuffers; ++j) {
                float *data = (float *)outputData->mBuffers[j].mData;
                if (data != NULL) {
                    data[i] = capped;
                }
            }
        }
        return noErr;
    }];
    [self.audioEngine attachNode:sourceNode];
    [self.audioEngine connect:sourceNode to:mainMixer format: inputFormat];
    [self.audioEngine connect:mainMixer to: output format:hardwareFormat];
    mainMixer.outputVolume = 0.5;
}

- (void)play {
    NSError *error = nil;
    [self.audioEngine startAndReturnError:&error];
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    AVAudioSessionRouteDescription *route = [AVAudioSession sharedInstance].currentRoute;
    NSLog(@"Current audio outputs: %@", route.outputs);
}

- (void)stop {
    [self.audioEngine stop];
}

@end
