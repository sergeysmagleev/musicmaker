//
//  sawtooth_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "sawtooth_wave.hpp"
#include "math.h"

float CSawtoothWave::shape(float value) {
    float normalizedPhase = fmod(value, M_PI * 2) / (M_PI * 2);
    return normalizedPhase * 2 - 1;
}

CSawtoothWave::CSawtoothWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CSawtoothWave::~CSawtoothWave() { }
