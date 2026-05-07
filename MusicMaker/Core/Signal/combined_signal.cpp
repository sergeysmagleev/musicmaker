//
//  combined_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "combined_signal.hpp"
#include <cmath>

static float normalizationFactorForAmplitudes(const std::vector<float> &amplitudes) {
    float total = 0.0f;
    for (float amplitude : amplitudes) {
        total += fabsf(amplitude);
    }
    return total > 1.0f ? total : 1.0f;
}

CCombinedSignal::CCombinedSignal(std::vector<CSignal*> _signals) : CSignal() {
    signals = _signals;
    amplitudes.reserve(signals.size());
    for (int i = 0; i < _signals.size(); ++i) {
        amplitudes.push_back(1.0);
    }
    normalization_factor = normalizationFactorForAmplitudes(amplitudes);
}

CCombinedSignal::CCombinedSignal(std::vector<CSignal*> _signals, std::vector<float> _amplitudes) : CSignal() {
    signals = _signals;
    amplitudes = _amplitudes;
    normalization_factor = normalizationFactorForAmplitudes(amplitudes);
}

CCombinedSignal::~CCombinedSignal() {
    for (int i = 0; i < signals.size(); ++i) {
        delete signals[i];
    }
    signals.clear();
    amplitudes.clear();
}

float CCombinedSignal::advanceTimeAndReturnValue(float time_increment) {
    float retVal = 0;
    for (int i = 0; i < signals.size(); ++i) {
        retVal += signals[i]->advanceTimeAndReturnValue(time_increment) * amplitudes[i];
    }
    return retVal / normalization_factor;
}

void CCombinedSignal::start() {
    for (int i = 0; i < signals.size(); ++i) {
        signals[i]->start();
    }
}

void CCombinedSignal::stop() {
    for (int i = 0; i < signals.size(); ++i) {
        signals[i]->stop();
    }
}

void CCombinedSignal::reset() {
    for (int i = 0; i < signals.size(); ++i) {
        signals[i]->reset();
    }
}
