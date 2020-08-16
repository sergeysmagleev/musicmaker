//
//  LiveTrack.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 05.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveTrack : NSObject

- (instancetype)initWithSampleRate:(float)sampleRate;

- (float) advanceTimeAndReturnNextValue;
- (void) addToneWithFrequency:(float)frequency lfoFrequency:(float)lfoFrequency isKick:(BOOL)isKick;
- (void) addSignals;
- (void) startPlayingNoteAtIndex:(int)index;
- (void) stopPlayingNoteAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
