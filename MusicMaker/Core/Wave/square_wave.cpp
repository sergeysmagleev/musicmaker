//
//  square_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "square_wave.hpp"
#include "math.h"

float CSquareWave::shape(float value) {
    return fmod(value, M_PI * 2) < M_PI ? 1 : 0;
}

CSquareWave::CSquareWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CSquareWave::~CSquareWave() { }
