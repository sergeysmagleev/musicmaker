//
//  AudioMixer.h
//  MusicMaker
//

#import <Foundation/Foundation.h>
#import "AudioRenderable.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioMixer : NSObject <AudioRenderable>

- (void)addRenderSource:(id<AudioRenderable>)renderSource;
- (void)removeAllRenderSources;
- (void)setGain:(float)gain forRenderSourceAtIndex:(NSInteger)index;
- (NSInteger)renderSourceCount;

@end

NS_ASSUME_NONNULL_END
