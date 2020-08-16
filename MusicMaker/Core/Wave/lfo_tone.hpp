//
//  lfo_tone.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef lfo_tone_hpp
#define lfo_tone_hpp

#include <stdio.h>
#include "wave.hpp"
#include "envelope.hpp"

class CLFOTone {
    CWave *wave;
    float lfoFrequency;
    CEnvelope *ampEnvelope;
    float startingTime;
    float phase;
    float lfoPhase;
    bool played;
    float sampleRate;
    float lastValue;
    
    float timeIncrement();
    
public:
    CLFOTone(CWave *_wave, CEnvelope *_ampEnvelope, float _lfoFrequency, float _sampleRate);
    ~CLFOTone();
    float advanceTimeAndReturnValue();
    void release();
    void start(float time);
};

#endif /* lfo_tone_hpp */
