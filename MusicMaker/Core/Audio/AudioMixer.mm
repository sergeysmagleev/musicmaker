//
//  AudioMixer.mm
//  MusicMaker
//

#import "AudioMixer.h"
#include "../DSP/dsp_primitives.hpp"
#include <vector>

@interface AudioMixerSource : NSObject

@property (nonatomic, weak) id<AudioRenderable> renderSource;
@property (nonatomic) float gain;

@end

@implementation AudioMixerSource
@end

@implementation AudioMixer {
    NSMutableArray<AudioMixerSource *> *sources;
    std::vector<float> scratchBuffer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        sources = [NSMutableArray array];
    }
    return self;
}

- (void)addRenderSource:(id<AudioRenderable>)renderSource {
    if (renderSource == nil) {
        return;
    }

    AudioMixerSource *source = [[AudioMixerSource alloc] init];
    source.renderSource = renderSource;
    source.gain = 1.0f;
    [sources addObject:source];
}

- (void)removeAllRenderSources {
    [sources removeAllObjects];
}

- (void)setGain:(float)gain forRenderSourceAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)sources.count) {
        return;
    }

    sources[(NSUInteger)index].gain = MAX(0.0f, gain);
}

- (NSInteger)renderSourceCount {
    return (NSInteger)sources.count;
}

- (void)renderBuffer:(float *)buffer frameCount:(NSInteger)frameCount {
    if (buffer == NULL || frameCount <= 0) {
        return;
    }

    for (NSInteger frame = 0; frame < frameCount; ++frame) {
        buffer[frame] = 0.0f;
    }

    if (sources.count == 0) {
        return;
    }

    if (scratchBuffer.size() < (size_t)frameCount) {
        scratchBuffer.resize((size_t)frameCount, 0.0f);
    }
    for (AudioMixerSource *source in sources) {
        id<AudioRenderable> renderSource = source.renderSource;
        if (renderSource == nil) {
            continue;
        }

        std::fill(scratchBuffer.begin(), scratchBuffer.begin() + frameCount, 0.0f);
        [renderSource renderBuffer:scratchBuffer.data() frameCount:frameCount];
        for (NSInteger frame = 0; frame < frameCount; ++frame) {
            buffer[frame] += scratchBuffer[(size_t)frame] * source.gain;
        }
    }

    for (NSInteger frame = 0; frame < frameCount; ++frame) {
        buffer[frame] = MusicMaker::DSP::softLimit(buffer[frame]);
    }
}

@end
