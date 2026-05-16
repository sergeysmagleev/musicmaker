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

- (BOOL)configureAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    BOOL didSetCategory = [session setCategory:AVAudioSessionCategoryPlayback
                                          mode:AVAudioSessionModeDefault
                                       options:0
                                         error:&error];
    if (!didSetCategory) {
        NSLog(@"Failed to set audio session category: %@", error.localizedDescription);
        return NO;
    }
    
    error = nil;
    BOOL didSetBufferDuration = [session setPreferredIOBufferDuration:0.005 error:&error];
    if (!didSetBufferDuration) {
        NSLog(@"Failed to set preferred audio buffer duration: %@", error.localizedDescription);
    }
    
    error = nil;
    BOOL didActivate = [session setActive:YES error:&error];
    if (!didActivate) {
        NSLog(@"Failed to activate audio session: %@", error.localizedDescription);
        return NO;
    }
    
    AVAudioSessionRouteDescription *route = session.currentRoute;
    NSLog(@"Current audio outputs: %@", route.outputs);
    return YES;
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
        id<AudioRenderable> renderSource = self.renderSource;
        if (renderSource == nil || outputData->mNumberBuffers == 0 || outputData->mBuffers[0].mData == NULL) {
            *isSilence = YES;
            return noErr;
        }
        
        float *primaryBuffer = (float *)outputData->mBuffers[0].mData;
        [renderSource renderBuffer:primaryBuffer frameCount:(NSInteger)frameCount];
        for (int i = 0; i < frameCount; ++i) {
            primaryBuffer[i] = MIN(1.0f, MAX(-1.0f, primaryBuffer[i]));
        }
        
        for (int j = 1; j < outputData->mNumberBuffers; ++j) {
            float *data = (float *)outputData->mBuffers[j].mData;
            if (data != NULL) {
                for (int i = 0; i < frameCount; ++i) {
                    data[i] = primaryBuffer[i];
                }
            }
        }
        *isSilence = NO;
        return noErr;
    }];
    [self.audioEngine attachNode:sourceNode];
    [self.audioEngine connect:sourceNode to:mainMixer format: inputFormat];
    [self.audioEngine connect:mainMixer to: output format:hardwareFormat];
    mainMixer.outputVolume = 0.5;
}

- (void)play {
    if (![self configureAudioSession]) {
        return;
    }
    
    NSError *error = nil;
    [self.audioEngine startAndReturnError:&error];
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
}

- (void)stop {
    [self.audioEngine stop];
}

@end
