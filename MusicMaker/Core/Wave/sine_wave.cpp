//
//  sine_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "sine_wave.hpp"
#include "math.h"

float CSineWave::shape(float value) {
    return sinf(value);
}

CSineWave::CSineWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CSineWave::~CSineWave() { }
