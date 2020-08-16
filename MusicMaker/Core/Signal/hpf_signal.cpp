//
//  hpf_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "hpf_signal.hpp"
#include "math.h"

CHighPassFilterSignal::CHighPassFilterSignal(CSignal * _main_signal, float _alpha) {
    main_signal = _main_signal;
    alpha = _alpha;
    previous_x = 0;
    previous_y = 0;
}

CHighPassFilterSignal::~CHighPassFilterSignal() {
    delete main_signal;
}

float CHighPassFilterSignal::advanceTimeAndReturnValue(float time_increment) {
    float value = main_signal->advanceTimeAndReturnValue(time_increment);
    previous_y = alpha * (previous_y + value - previous_x);
    previous_x = value;
    return previous_y;
}

void CHighPassFilterSignal::start() {
    previous_y = 0;
    main_signal->start();
}

void CHighPassFilterSignal::stop() {
    main_signal->stop();
}
