//
//  waveform_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "waveform_signal.hpp"
#include <math.h>

CWaveformSignal::CWaveformSignal(std::vector<CWave*> _waves, std::vector<float> _amplitudes) : CSignal() {
    waves = _waves;
    amplitudes = _amplitudes;
    mltplr = 0.0;
}

CWaveformSignal::CWaveformSignal(CWave *wave) {
    waves.push_back(wave);
    amplitudes.push_back(1.0);
    mltplr = 0.0;
}

CWaveformSignal::~CWaveformSignal() {
    for (int i = 0; i < waves.size(); ++i) {
        delete waves[i];
    }
    waves.clear();
    amplitudes.clear();
}

float CWaveformSignal::advanceTimeAndReturnValue(float time_increment) {
    float retVal = 0;
    for (int i = 0; i < waves.size(); ++i) {
        retVal += waves[i]->play(time_increment) * amplitudes[i];
    }
    return retVal;
}

void CWaveformSignal::start() {
    
}

void CWaveformSignal::stop() {

}
