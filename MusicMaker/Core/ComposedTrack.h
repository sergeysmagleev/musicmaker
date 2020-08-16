//
//  ComposedTrack.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposedTrack : NSObject

- (void)start;
- (void)stop;
- (float)next_sample;
- (void)clearBuffers;
- (void)reset;
- (void)toggleBeatForInstrument:(NSInteger)instrument beat:(NSInteger)beat drumId:(NSString *)drumId;

@end

NS_ASSUME_NONNULL_END
