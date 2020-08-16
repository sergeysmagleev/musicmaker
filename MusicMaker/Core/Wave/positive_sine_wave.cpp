//
//  positive_sine_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 06.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "positive_sine_wave.hpp"
#include "math.h"

float CPositiveSineWave::shape(float value) {
    float ret_val = 0.5 + sinf(value) / 2;
    if (ret_val < 0) {
        return 0;
    }
    if (ret_val > 1) {
        return 1;
    }
    return ret_val;
}

CPositiveSineWave::CPositiveSineWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CPositiveSineWave::~CPositiveSineWave() { }
