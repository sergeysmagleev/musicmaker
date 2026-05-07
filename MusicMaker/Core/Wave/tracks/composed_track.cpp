//
//  composed_track.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "composed_track.hpp"
#include <limits.h>
#include <assert.h>
#include "math.h"

static const float time_increment = 1.0 / 44100;

CComposedTrack::CComposedTrack(std::vector<CSignal *> _signals) {
//    signals = _signals;
    
    whole = 88200 * 0.8;
    half = whole / 2;
    quarter = whole / 4;
    eights = whole / 8;
    sixteenth = whole / 16;
    tt = whole / 32;
    drum_loop = new CComposedLoop(_signals);
    drum_loop->change_bpm(96);
//    drum_loop->add_interval(0, 0, 1);
//    drum_loop->add_interval(0, 16, 17);
//    drum_loop->add_interval(0, 32, 33);
//    drum_loop->add_interval(0, 48, 49);
}

CComposedTrack::~CComposedTrack() {
//    delete kick_drum;
//    delete snare_drum;
//    delete hihat;
    delete drum_loop;
}

float CComposedTrack::play_next_frame() {
    return drum_loop->PlayNextFrame();
}

void CComposedTrack::toggle_signal(int signal_index, int beat, int length, std::string _uuid) {
    assert(length >= 1);
    drum_loop->ToggleInterval(signal_index, beat, beat + length, _uuid);
}

void CComposedTrack::add_signal(int signal_index, int beat, int length, std::string _uuid) {
    assert(length >= 1);
    drum_loop->AddInterval(signal_index, beat, beat + length, _uuid);
}

void CComposedTrack::remove_signal(int signal_index, std::string _uuid) {
    drum_loop->RemoveInterval(signal_index, _uuid);
}

void CComposedTrack::StartPlaying() {
    drum_loop->PrepareIntervals();
}

void CComposedTrack::StopPlaying() {
    drum_loop->stop();
}

//float CComposedTrack::play_next_frame() {
//    if (timer % (whole * 4) == 0) {
//        synth->start();
//    }
//    if (timer % (whole * 4) - (whole) + eights == 0) {
//        synth->stop();
//    }
//    if (timer % (whole * 4) - whole == 0) {
//        synth2->start();
//    }
//    if (timer % (whole * 4) - whole * 2 + eights == 0) {
//        synth2->stop();
//    }
//    if (timer % (whole * 4) - whole * 2 == 0) {
//        synth3->start();
//    }
//    if (timer % (whole * 4) - whole * 4 + eights == 0) {
//        synth3->stop();
//    }
//    if (timer % (whole * 2) == 0) {
//        bass->start();
//    }
//    if (timer % (whole * 2) - eights - sixteenth - tt == 0) {
//        bass->stop();
//    }
//
//    if (timer % (whole * 2) - quarter == 0) {
//        bass->start();
//    }
//    if (timer % (whole * 2) - quarter - sixteenth - tt == 0) {
//        bass->stop();
//    }
//
//    if (timer % (whole * 2) - whole - quarter - eights == 0) {
//        bass->start();
//    }
//    if (timer % (whole * 2) - whole - quarter - eights - tt == 0) {
//        bass->stop();
//    }
//    if (timer % (whole * 2) - whole - quarter - eights - sixteenth == 0) {
//        bass->start();
//    }
//    if (timer % (whole * 2) - whole - quarter - eights - sixteenth - tt == 0) {
//        bass->stop();
//    }
//
//    if (timer % whole - half- eights - sixteenth == 0) {
//        bass2->start();
//    }
//    if (timer % whole - half- quarter - eights - tt == 0) {
//        bass2->stop();
//    }
//
//    if (timer % eights == 0) {
//        hihat->start();
//    }
//
////    if (timer % whole == 0) {
////        kick_drum->start();
////    }
////    if (timer % whole - eights == 0) {
////        snare_drum->start();
////    }
//    if (timer % whole - eights == 0) {
//        kick_drum->start();
//    }
////    if (timer % whole - eights - sixteenth == 0) {
////        kick_drum->start();
////    }
////    if (timer % whole - quarter - sixteenth == 0) {
////        kick_drum->start();
////    }
//    if (timer % whole - quarter - eights == 0) {
//        snare_drum->start();
//    }
////    if (timer % whole - quarter - eights - sixteenth - tt == 0) {
////        snare_drum->start();
////    }
//    if (timer % whole - half == 0) {
//        kick_drum->start();
//    }
////    if (timer % whole - half - eights == 0) {
////        snare_drum->start();
////    }
////    if (timer % whole - half - eights - sixteenth == 0) {
////        kick_drum->start();
////    }
////    if (timer % whole - half - quarter == 0) {
////        kick_drum->start();
////    }
//    if (timer % whole - half- quarter - sixteenth == 0) {
//        kick_drum->start();
//    }
//    if (timer % whole - half- quarter - eights == 0) {
//        snare_drum->start();
//    }
////    if (timer % whole - half - quarter - eights - sixteenth == 0) {
////        kick_drum->start();
////    }
////    if (timer % whole - half - quarter - eights - sixteenth - tt == 0) {
////        snare_drum->start();
////    }
//    timer += 1;
//    if (timer >= ULONG_MAX) {
//        timer = 0;
//    }
//    return
////    hihat->advanceTimeAndReturnValue(time_increment) +
////    kick_drum->advanceTimeAndReturnValue(time_increment) +
////    snare_drum->advanceTimeAndReturnValue(time_increment) +
////    bass->advanceTimeAndReturnValue(time_increment) +
////    bass2->advanceTimeAndReturnValue(time_increment) +
//    synth->advanceTimeAndReturnValue(time_increment) +
//    synth2->advanceTimeAndReturnValue(time_increment) +
//    synth3->advanceTimeAndReturnValue(time_increment);
//}
