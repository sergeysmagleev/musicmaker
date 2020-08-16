//
//  lpf_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "lpf_signal.hpp"
#include "math.h"

CLowPassFilterSignal::CLowPassFilterSignal(CSignal * _main_signal, float _alpha) {
    main_signal = _main_signal;
    alpha = _alpha;
    last_value = 0;
}

CLowPassFilterSignal::~CLowPassFilterSignal() {
    delete main_signal;
}

float CLowPassFilterSignal::advanceTimeAndReturnValue(float time_increment) {
    float value = main_signal->advanceTimeAndReturnValue(time_increment);
    last_value = last_value + alpha * (value - last_value);
    return last_value;
}

void CLowPassFilterSignal::start() {
    last_value = 0;
    main_signal->start();
}

void CLowPassFilterSignal::stop() {
    main_signal->stop();
}
