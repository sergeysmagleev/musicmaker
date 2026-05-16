//
//  AudioRenderable.h
//  MusicMaker
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioRenderable <NSObject>

- (void)renderBuffer:(float *)buffer frameCount:(NSInteger)frameCount;

@end

NS_ASSUME_NONNULL_END
