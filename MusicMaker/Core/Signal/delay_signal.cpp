//
//  delay_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "delay_signal.hpp"
#include <stdlib.h>
#include "math.h"
#include <ctime>
#include "allpass_filter.hpp"
#include "comb_filter.hpp"

CDelaySignal::CDelaySignal(CSignal *_signal, float _dry_gain) : CSignal() {
    signal = _signal;
    allpass_filters.push_back(new CAllpassFilter(37));
//    allpass_filters.push_back(new CAllpassFilter(113));
    allpass_filters.push_back(new CAllpassFilter(347));
//    allpass_filters.push_back(new CAllpassFilter(513));
    allpass_filters.push_back(new CAllpassFilter(737));
//    allpass_filters.push_back(new CAllpassFilter(1311));
    allpass_filters.push_back(new CAllpassFilter(2031));
//    allpass_filters.push_back(new CAllpassFilter(3391));
//    allpass_filters.push_back(new CAllpassFilter(4973));
    comb_filters.push_back(new CCombFilter(337));
    comb_filters.push_back(new CCombFilter(653));
    comb_filters.push_back(new CCombFilter(893));
    comb_filters.push_back(new CCombFilter(911));
    comb_filters.push_back(new CCombFilter(1031));
    comb_filters.push_back(new CCombFilter(1311));
    comb_filters.push_back(new CCombFilter(1917));
}

CDelaySignal::~CDelaySignal() {
    delete signal;
    for (int i = 0; i < allpass_filters.size(); ++i) {
        delete allpass_filters[i];
    }
    allpass_filters.clear();
    for (int i = 0; i < comb_filters.size(); ++i) {
        delete comb_filters[i];
    }
    comb_filters.clear();
}

float CDelaySignal::advanceTimeAndReturnValue(float time_increment) {
    mutex.lock();
    float value = signal->advanceTimeAndReturnValue(time_increment);
    // allpass
    for (int i = 0; i < allpass_filters.size(); ++i) {
        value = allpass_filters[i]->filter(value);
    }
    
    // comb
    float part = 0.9 / comb_filters.size();
    float combval = 0;
    for (int i = 0; i < comb_filters.size(); ++i) {
        float delay = comb_filters[i]->filter(value);
        combval += delay * part;
    }
    value = combval;
    mutex.unlock();
    return value;
}

void CDelaySignal::start() {
    signal->start();
}

void CDelaySignal::stop() {
    signal->stop();
}

void CDelaySignal::reset() {
    mutex.lock();
    signal->reset();
    for (int i = 0; i < allpass_filters.size(); ++i) {
        allpass_filters[i]->reset();
    }
    for (int i = 0; i < comb_filters.size(); ++i) {
        comb_filters[i]->reset();
    }
    mutex.unlock();
}
