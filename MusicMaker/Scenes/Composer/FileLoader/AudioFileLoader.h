//
//  AudioFileLoader.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 23.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioFileLoader : NSObject

- (NSData *)audioFileReaderWithData:(NSData *)audioData;

@end

NS_ASSUME_NONNULL_END
