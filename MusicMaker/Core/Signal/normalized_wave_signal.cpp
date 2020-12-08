//
//  normalized_wave_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "normalized_wave_signal.hpp"

CNormalizedWaveSignal::CNormalizedWaveSignal(CSignal * _signal) {
    signal = _signal;
}

CNormalizedWaveSignal::~CNormalizedWaveSignal() {
    delete signal;
}

float CNormalizedWaveSignal::advanceTimeAndReturnValue(float time_increment) {
    return signal->advanceTimeAndReturnValue(time_increment) * 0.5 + 0.5;
}

void CNormalizedWaveSignal::start() {
    signal->start();
}

void CNormalizedWaveSignal::stop() {
    signal->stop();
}

void CNormalizedWaveSignal::reset() {
    signal->reset();
}
