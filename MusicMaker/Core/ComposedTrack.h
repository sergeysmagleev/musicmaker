//
//  ComposedTrack.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ComposedTrack;

@protocol ComposedTrackDelegate <NSObject>

- (void)composedTrack:(ComposedTrack *)track didPrepareBuffer:(const float *)buffer;

@end

@interface ComposedTrack : NSObject

@property (nonatomic, weak) id<ComposedTrackDelegate> delegate;

- (void)start;
- (void)stop;
- (float)next_sample;
- (void)clearBuffers;
- (void)reset;
- (void)toggleBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat length:(NSInteger)length drumId:(NSString *)drumId;
- (void)addBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat length:(NSInteger)length drumId:(NSString *)drumId;
- (void)removeBeatForInstrument:(NSInteger)instrument drumId:(NSString *)drumId;
- (const float *)replayValues;

@end

NS_ASSUME_NONNULL_END
