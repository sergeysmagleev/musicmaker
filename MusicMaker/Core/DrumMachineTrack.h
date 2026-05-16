//
//  DrumMachineTrack.h
//  MusicMaker
//

#import <Foundation/Foundation.h>
#import "Audio/AudioRenderable.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrumMachineTrack : NSObject <AudioRenderable>

- (instancetype)initWithSampleRate:(double)sampleRate;
- (void)start;
- (void)stop;
- (void)reset;
- (void)renderBuffer:(float *)buffer frameCount:(NSInteger)frameCount;
- (void)setBPM:(NSInteger)bpm;
- (void)setStepForInstrument:(NSInteger)instrument beat:(NSInteger)beat active:(BOOL)active;
- (void)toggleStepForInstrument:(NSInteger)instrument beat:(NSInteger)beat;
- (BOOL)isStepActiveForInstrument:(NSInteger)instrument beat:(NSInteger)beat;

@end

NS_ASSUME_NONNULL_END
