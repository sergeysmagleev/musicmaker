//
//  pcm_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "pcm_signal.hpp"
#include <stdlib.h>
#include <string.h>
#include <limits.h>

CPCMSignal::CPCMSignal(int16_t * _bytes, int32_t _bytecount) {
    bytes = (int16_t *)malloc(sizeof(int16_t) * _bytecount);
    bytecount = _bytecount;
    memcpy(bytes, _bytes, _bytecount * sizeof(int16_t));
    position = 0;
}

CPCMSignal::~CPCMSignal() {
    free(bytes);
}

float CPCMSignal::advanceTimeAndReturnValue(float time_increment) {
    if (position >= bytecount) {
        return 0;
    }
    return float(bytes[position++]) / float(SHRT_MAX);
}

void CPCMSignal::start() {
    position = 0;
}

void CPCMSignal::stop() {
    
}

void CPCMSignal::reset() {
    position = 0;
}

int32_t CPCMSignal::length() {
    return bytecount;
}
