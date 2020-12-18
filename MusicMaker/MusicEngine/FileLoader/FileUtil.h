//
//  FileUtil.h
//  MusicMaker
//
//  Created by Sergey Smagleev on 25.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#import <Foundation/Foundation.h>

static OSStatus readProc(void* clientData,
                         SInt64 position,
                         UInt32 requestCount,
                         void* buffer,
                         UInt32* actualCount)
{
    NSData *inAudioData = (__bridge NSData *)clientData;
    size_t dataSize = inAudioData.length;
    size_t bytesToRead = 0;
    if (position < dataSize) {
        size_t bytesAvailable = dataSize - position;
        bytesToRead = requestCount <= bytesAvailable ? requestCount : bytesAvailable;
        
        [inAudioData getBytes: buffer range:NSMakeRange(position, bytesToRead)];
    } else {
        NSLog(@"data was not read \n");
        bytesToRead = 0;
    }
    if (actualCount) {
        *actualCount = (UInt32)bytesToRead;
    }
    return noErr;
}

static SInt64 getSizeProc(void* clientData)
{
    NSData *inAudioData = (__bridge NSData *)clientData;
    size_t dataSize = inAudioData.length;
    return dataSize;
}
