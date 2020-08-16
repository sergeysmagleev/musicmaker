//
//  pcm_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef pcm_signal_hpp
#define pcm_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CPCMSignal: public CSignal {
    int16_t * bytes;
    int32_t bytecount;
    int32_t position;
public:
    CPCMSignal(int16_t * _bytes, int32_t _bytecount);
    virtual ~CPCMSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    int32_t length();
};

#endif /* pcm_signal_hpp */
