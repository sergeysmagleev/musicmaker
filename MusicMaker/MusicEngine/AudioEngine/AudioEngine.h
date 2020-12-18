//
//  AudioEngine.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.12.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioEngineDelegate <NSObject>

- (float)audioEngineValueForNextFrame;

@end

@interface AudioEngine : NSObject

@property (nonatomic, weak) id<AudioEngineDelegate> delegate;

- (void)play;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
