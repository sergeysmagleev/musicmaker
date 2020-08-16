//
//  wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "wave.hpp"
#include "math.h"

CWave::CWave(float _frequency, float _amplitude, float _phaseShift) {
    frequency = _frequency;
    amplitude = _amplitude;
    phaseShift = _phaseShift;
    phase = 0;
}

CWave::~CWave() {
    
}

float CWave::play(float time_increment) {
    phase += (M_PI * 2 * frequency) * time_increment;
    while (phase > M_PI * 2) {
        phase -= M_PI * 2;
    }
    return shape(phaseShift + phase) * amplitude;
}
