//
//  composed_loop.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 19.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "composed_loop.hpp"
#include <assert.h>
#include "math.h"
#include "global_constants.h"

const float time_increment = 1.0f / (float)SAMPLE_RATE;

CComposedLoop::CComposedLoop(std::vector<CSignal*> _signals) : store((int)_signals.size()) {
    signals = _signals;
}

CComposedLoop::~CComposedLoop() {
    for (int i = 0; i < signals.size(); ++i) {
        delete signals[i];
    }
    signals.clear();
}

void CComposedLoop::reset_loop() {
    timer = 0;
    current_beat = -1;
    store.ResetIndexes();
}

float CComposedLoop::PlayNextFrame() {
    assert(increment > 0);
    assert(length > 0);
    if (timer % increment == 0) {
        ++current_beat;
        StartNextBeat();
    }
    float signal = 0;
    for (int i = 0; i < signals.size(); ++i) {
        signal += signals[i]->advanceTimeAndReturnValue(time_increment);
    }
    if (++timer >= length) {
        reset_loop();
    }
    return signal;
}

void CComposedLoop::StartNextBeat() {
    for (int i = 0; i < signals.size(); ++i) {
        CInterval<uint8_t> current_interval = store.CurrentInterval(i);
        if (current_interval.end == current_beat) {
            signals[i]->stop();
            current_interval = store.NextInterval(i);
        }
        if (current_interval.start == current_beat) {
            signals[i]->start();
        }
    }
}

void CComposedLoop::PrepareIntervals() {
    store.ResetIntervals();
}

void CComposedLoop::stop() {
    reset_loop();
    store.ResetIntervals();
}

void CComposedLoop::ToggleInterval(int index, uint8_t begin, uint8_t end, std::string _uuid) {
    store.ToggleInterval(index, {begin, end}, _uuid);
}

void CComposedLoop::AddInterval(int index, uint8_t begin, uint8_t end, std::string _uuid) {
    store.AddInterval(index, {begin, end}, _uuid);
}

void CComposedLoop::RemoveInterval(int index, std::string _uuid) {
    store.RemoveInterval(index, _uuid);
}

void CComposedLoop::change_bpm(const int _bpm) {
    bpm = _bpm;
    increment = (int)(truncf((60.0f * (float)SAMPLE_RATE) / ((float)bpm * 4.0f)));
    length = increment * 64;
    reset_loop();
}

void CComposedLoop::set_increment(const int _increment) {
    increment = _increment;
    length = increment * 64;
    reset_loop();
}
