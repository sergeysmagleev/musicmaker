//
//  lfo_tone.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "lfo_tone.hpp"
#include "math.h"
    
float CLFOTone::timeIncrement() {
    return 1 / sampleRate;
}
    
CLFOTone::CLFOTone(CWave *_wave, CEnvelope *_ampEnvelope, float _lfoFrequency, float _sampleRate) {
    wave = _wave;
    ampEnvelope = _ampEnvelope;
    lfoFrequency = _lfoFrequency;
    sampleRate = _sampleRate;
    phase = 0;
    lfoPhase = 0;
    startingTime = 0;
    played = false;
    lastValue = 0;
}

CLFOTone::~CLFOTone() {
    delete wave;
    delete ampEnvelope;
}

float CLFOTone::advanceTimeAndReturnValue() {
    if (played == false) {
        return 0.0;
    }
    lfoPhase += timeIncrement();
    while (lfoPhase > M_PI * 2) {
        lfoPhase -= M_PI * 2;
    }
    phase += timeIncrement();// * (1 + (sin(Float.pi * 2 * lfoFrequency * lfoPhase) + 1))
    while (phase > M_PI * 2) {
        phase -= M_PI * 2;
    }
    //x = phase
    //y(x) = tone(x) * amp
//    float tau = 0.02;
    const float alpha = fabs(sin(M_PI * 2 * lfoFrequency * lfoPhase)) / 20;
    float value = wave->play(phase);// * ampEnvelope->advanceTimeAndReturnValue();
    lastValue += alpha * (value - lastValue);
    return lastValue;
}

void CLFOTone::release() {
    
}
    
void CLFOTone::start(float time) {
    played = true;
    startingTime = time;
    ampEnvelope->stop();
}
