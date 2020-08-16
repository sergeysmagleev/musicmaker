//
//  triangle_wave.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "triangle_wave.hpp"
#include "math.h"

float CTriangleWave::shape(float value) {
    float phase = fmod(value, M_PI * 2);
    if (phase < M_PI) {
        return phase / M_PI - 0.5;
    } else {
        return 0.5 - (phase - M_PI) / M_PI;
    }
}

CTriangleWave::CTriangleWave(float _frequency, float _amplitude, float _phaseShift) : CWave(_frequency, _amplitude, _phaseShift) { }

CTriangleWave::~CTriangleWave() { }
