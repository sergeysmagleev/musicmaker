//
//  RecordedTrack.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecordedTrackDelegate <NSObject>

- (void)recordedTrackDidGetNewBuffer:(SInt16 *)data length:(NSUInteger)length;

@end

@interface RecordedTrack : NSObject

@property (nonatomic, weak) id<RecordedTrackDelegate> delegate;

- (NSUInteger)wave_buffer_size;

- (instancetype)init;
- (float *)get_points;
- (int)get_points_count;
- (float *)get_frequency_analysis;

- (void)start;
- (void)stop;
- (float)next_sample;
- (float *)wave_fragment;
- (float *)frequency_fragment;
- (void)prepareWaveFragment;

@end

NS_ASSUME_NONNULL_END
