//
//  AudioFileReader.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 25.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioFileReaderDelegate <NSObject>

- (void)audioFileReaderDidGetNewBuffer:(NSData *)data;

@end

@interface AudioFileReader : NSObject

@property (nonatomic, weak) id<AudioFileReaderDelegate> delegate;

- (void)prepareAudioFileFromURLAsync:(NSURL *)url;
- (void)prepareAudioFileFromURL:(NSURL *)url;
- (float)readNextValue;

@end

NS_ASSUME_NONNULL_END
