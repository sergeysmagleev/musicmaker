//
//  noise_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "noise_wave.hpp"

#include "math.h"
#include <stdlib.h>

float CNoiseWave::shape(float value) {
    return (drand48() - drand48()) * (frequency == 0 ? 1 : fabsf(sinf(value)));
}

CNoiseWave::CNoiseWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CNoiseWave::~CNoiseWave() { }
