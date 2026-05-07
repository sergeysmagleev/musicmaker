//
//  modulated_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "modulated_signal.hpp"
#include "waveform_signal.hpp"
#include <cmath>

CModulatedSignal::CModulatedSignal(CSignal * _main_signal,
                                   CSignal * _amp_modulator,
                                   CSignal * _freq_modulator) {
    main_signal = _main_signal;
    amp_modulator = _amp_modulator;
    freq_modulator = _freq_modulator;
}
CModulatedSignal::CModulatedSignal(CWave * _main_wave,
                                   CWave * _amp_modulator_wave,
                                   CWave * _freq_modulator_wave) {
    main_signal = _main_wave == nullptr ? nullptr : new CWaveformSignal(_main_wave);
    amp_modulator = _amp_modulator_wave == nullptr ? nullptr : new CWaveformSignal(_amp_modulator_wave);
    freq_modulator = _freq_modulator_wave == nullptr ? nullptr : new CWaveformSignal(_freq_modulator_wave);
}

CModulatedSignal::CModulatedSignal(CSignal * _main_signal,
                                   CWave * _amp_modulator_wave,
                                   CWave * _freq_modulator_wave) {
    main_signal = _main_signal;
    amp_modulator = _amp_modulator_wave == nullptr ? nullptr : new CWaveformSignal(_amp_modulator_wave);
    freq_modulator = _freq_modulator_wave == nullptr ? nullptr : new CWaveformSignal(_freq_modulator_wave);
}

CModulatedSignal::~CModulatedSignal() {
    delete main_signal;
    if (amp_modulator != nullptr) {
        delete amp_modulator;
    }
    if (freq_modulator != nullptr) {
        delete freq_modulator;
    }
}

float CModulatedSignal::advanceTimeAndReturnValue(float time_increment) {
    if (main_signal == nullptr) {
        return 0;
    }
    float amp_multiplier = (amp_modulator == nullptr) ? 1.0 : amp_modulator->advanceTimeAndReturnValue(time_increment);
    if (amp_multiplier == 0) {
        return 0;
    }
    float freq_multiplier = 1.0f;
    if (freq_modulator != nullptr) {
        float modulator_value = freq_modulator->advanceTimeAndReturnValue(time_increment);
        freq_multiplier = 1.0f + 0.5f * modulator_value;
        if (!std::isfinite(freq_multiplier)) {
            freq_multiplier = 1.0f;
        }
        if (freq_multiplier < 0.25f) {
            freq_multiplier = 0.25f;
        } else if (freq_multiplier > 4.0f) {
            freq_multiplier = 4.0f;
        }
    }
    return main_signal->advanceTimeAndReturnValue(time_increment * freq_multiplier) * amp_multiplier;
}

void CModulatedSignal::start() {
    if (main_signal != nullptr) { main_signal->start(); }
    if (amp_modulator != nullptr) { amp_modulator->start(); }
    if (freq_modulator != nullptr) { freq_modulator->start(); }
}

void CModulatedSignal::stop() {
    if (main_signal != nullptr) { main_signal->stop(); }
    if (amp_modulator != nullptr) { amp_modulator->stop(); }
    if (freq_modulator != nullptr) { freq_modulator->stop(); }
}

void CModulatedSignal::reset() {
    if (main_signal != nullptr) { main_signal->reset(); }
    if (amp_modulator != nullptr) { amp_modulator->reset(); }
    if (freq_modulator != nullptr) { freq_modulator->reset(); }
}
