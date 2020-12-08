//
//  amplified_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "amplified_signal.hpp"

CAmplifiedSignal::CAmplifiedSignal(CSignal *_signal, float _amplifier) : CSignal() {
    signal = _signal;
    amplifier = _amplifier;
}

CAmplifiedSignal::~CAmplifiedSignal() {
    delete signal;
}

float CAmplifiedSignal::advanceTimeAndReturnValue(float time_increment) {
    return signal->advanceTimeAndReturnValue(time_increment) * amplifier;
}

void CAmplifiedSignal::start() {
    signal->start();
}

void CAmplifiedSignal::stop() {
    signal->stop();
}

void CAmplifiedSignal::reset() {
    signal->reset();
}
