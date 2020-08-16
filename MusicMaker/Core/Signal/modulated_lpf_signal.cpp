//
//  modulated_lpf_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 02.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "modulated_lpf_signal.hpp"
#include "math.h"

CModulatedLPFSignal::CModulatedLPFSignal(CSignal * _main_signal,
                                         CSignal * _modulating_signal,
                                         bool _negative) : CSignal() {
    main_signal = _main_signal;
    modulating_signal = _modulating_signal;
    negative = _negative;
}

CModulatedLPFSignal::~CModulatedLPFSignal() {
    delete main_signal;
    delete modulating_signal;
}

float CModulatedLPFSignal::advanceTimeAndReturnValue(float time_increment) {
    float value = main_signal->advanceTimeAndReturnValue(time_increment);
    float modulator = modulating_signal->advanceTimeAndReturnValue(time_increment);
    last_value = last_value + (negative ? fabs(1 - modulator) : fabs(modulator)) * (value - last_value);
    return last_value;
}

void CModulatedLPFSignal::start() {
    main_signal->start();
    modulating_signal->start();
}

void CModulatedLPFSignal::stop() {
    main_signal->stop();
    modulating_signal->stop();
}
