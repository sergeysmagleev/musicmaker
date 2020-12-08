//
//  live_track.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "live_track.hpp"
#include "math.h"
#include "signal_factory.hpp"
#include <vector>
#include "note.h"

float CLiveTrack::timeIncrement() {
    return 1 / sampleRate;
}

CLiveTrack::CLiveTrack(float _sampleRate) {
    sampleRate = _sampleRate;
}

CLiveTrack::~CLiveTrack() {
    for (int i = 0; i < signals.size(); ++i) {
        delete signals[i];
    }
    signals.clear();
}

float CLiveTrack::advanceTimeAndReturnNextValue() {
    currentLFOTimeStamp += timeIncrement() * lfoFrequency;
    currentTimeStamp += timeIncrement() * (sinf(currentLFOTimeStamp));
    float sum = 0.0;
    for (int i = 0; i < signals.size(); ++i) {
        sum += signals[i]->advanceTimeAndReturnValue(timeIncrement());
    }
    return sum;
}

void CLiveTrack::addSignal(bool kick, float frequency) {
    CSignal *kick_drum = kick ? CSignalFactory::kickDrum(frequency) : CSignalFactory::snareDrum();
    signals.push_back(kick_drum);
}

void CLiveTrack::addSignals() {
    signals = {
//        CSignalFactory::kick_main(130.81),
//        CSignalFactory::kick_noise(130.81),
//        CSignalFactory::kickDrum(130.81),
//        CSignalFactory::snare_main(),
//        CSignalFactory::snare_transient(),
//        CSignalFactory::snare_noise(),
//        CSignalFactory::snareDrum(),
//        CSignalFactory::hihat_drum(),
//        CSignalFactory::chord(261.63, 329.63, 392.00),
//        CSignalFactory::single_reverb_chord(261.63, 329.63, 392.00),
//        CSignalFactory::quick_noise(),

////        CSignalFactory::bell_thingy(noteAb6),
        CSignalFactory::bell_thingy(noteA6),
        CSignalFactory::bell_thingy(noteB6),
        CSignalFactory::bell_thingy(noteC7),
        CSignalFactory::bell_thingy(noteD7),
        CSignalFactory::bell_thingy(noteE7),
        CSignalFactory::bell_thingy(noteF7),
//        CSignalFactory::separate_reverb_chord(87.31, 110.00, 130.81),
//        CSignalFactory::separate_reverb_chord(98.00, 116.54, 146.83),
//        CSignalFactory::chord(1318.51, 1567.98, 1975.53),
//        CSignalFactory::separate_reverb_chord(1318.51, 1567.98, 1975.53),
        CSignalFactory::single_reverb_chord(87.31, 110.00, 130.81),
        CSignalFactory::single_reverb_chord(98.00, 116.54, 146.83),
        CSignalFactory::single_reverb_chord(1318.51, 1567.98, 1975.53),
        CSignalFactory::single_reverb_chord(3520.00, 4186.01, 5274.04),
        CSignalFactory::chord(87.31, 110.00, 130.81),
        CSignalFactory::chord(98.00, 116.54, 146.83),
        CSignalFactory::chord(1318.51, 1567.98, 1975.53),
        CSignalFactory::chord(3520.00, 4186.01, 5274.04),
        CSignalFactory::synth_string(noteC5),
        CSignalFactory::synth_string(noteDb5),
        CSignalFactory::synth_string(noteD5),
        CSignalFactory::synth_string(noteEb5),
        CSignalFactory::synth_string(noteE5),
        CSignalFactory::synth_string(noteF5),
        CSignalFactory::synth_string(noteGb5),
        CSignalFactory::synth_string(noteG5),
        CSignalFactory::synth_string(noteC5),
        CSignalFactory::synth_string(noteC5)
//        CSignalFactory::modulated_bass(41.20, 43.65)
//        CSignalFactory::modulated_bass(43.65),
//        CSignalFactory::modulated_bass(46.25)
    };
}

void CLiveTrack::startPlayingNote(int index) {
    signals[index]->start();
}

void CLiveTrack::stopPlayingNote(int index) {
    signals[index]->stop();
}
