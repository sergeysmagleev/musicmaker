//
//  AudioEngine.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.12.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../Core/Audio/AudioRenderable.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioEngine : NSObject

@property (nonatomic, weak, nullable) id<AudioRenderable> renderSource;
@property (nonatomic, readonly) double sampleRate;

- (void)play;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
