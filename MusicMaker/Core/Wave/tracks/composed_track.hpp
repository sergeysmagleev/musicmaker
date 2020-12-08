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
#include <vector>
#include "signal.hpp"
#include "composed_loop.hpp"

class CComposedTrack {
    
//    std::vector<CSignal *> signals;
    unsigned long timer = 0;
    int whole;
    int half;
    int quarter;
    int eights;
    int sixteenth;
    int tt;
    CComposedLoop *drum_loop;
    
public:
    CComposedTrack(std::vector<CSignal *> _signals);
    virtual ~CComposedTrack();
    
    float play_next_frame();
    void toggle_signal(int signal_index, int beat, int length, std::string _uuid);
    void add_signal(int signal_index, int beat, int length, std::string _uuid);
    void remove_signal(int signal_index, std::string _uuid);
    void StartPlaying();
    void StopPlaying();
};

#endif /* composed_track_hpp */
