//
//  live_track.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef live_track_hpp
#define live_track_hpp

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "lfo_tone.hpp"
#include "signal.hpp"

class CLiveTrack {
//    CLFOTone tones[5];
    std::vector<CSignal*> signals;
    float currentTimeStamp;
    float currentLFOTimeStamp;
    float lfoFrequency;
    float sampleRate;
    float timeIncrement();
    
public:
    CLiveTrack(float _sampleRate);
    virtual ~CLiveTrack();
    float advanceTimeAndReturnNextValue();
    void addSignal(bool kick, float frequency);
    void addSignals();
    void startPlayingNote(int index);
    void stopPlayingNote(int index);
};

#endif /* live_track_hpp */
