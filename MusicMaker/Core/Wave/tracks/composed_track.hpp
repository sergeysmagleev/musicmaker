//
//  composed_track.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef composed_track_hpp
#define composed_track_hpp

#include <stdio.h>
#include <string>
#include "signal.hpp"
#include "composed_loop.hpp"

class CComposedTrack {
    
    CSignal *kick_drum;
    CSignal *snare_drum;
    CSignal *hihat;
    CSignal *bass;
    CSignal *bass2;
    CSignal *synth;
    CSignal *synth2;
    CSignal *synth3;
    unsigned long timer = 0;
    int whole;
    int half;
    int quarter;
    int eights;
    int sixteenth;
    int tt;
    CComposedLoop *drum_loop;
    
public:
    CComposedTrack(CSignal * _kick_drum,
                   CSignal * _snare_drum,
                   CSignal * _hihat,
                   CSignal * _bass,
                   CSignal * _bass2,
                   CSignal * _synth,
                   CSignal * _synth2,
                   CSignal * _synth3);
    virtual ~CComposedTrack();
    
    float play_next_frame();
    void toggle_signal(int signal_index, int beat, std::string _uuid);
    void StartPlaying();
    void StopPlaying();
};

#endif /* composed_track_hpp */
