//
//  linear_envelope.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef linear_envelope_hpp
#define linear_envelope_hpp

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "signal.hpp"
#include "envelope.hpp"

class CLinearEnvelope: public CSignal {
    float startingTime;
    float attackDuration;
    float decayDuration;
    float releaseDuration;
    float sustainAmplitude;
    float releaseTime;
    float latestPlayTime;
    float time = 0;
    std::vector<CKeyFrame> key_frame_points;
    int keyFrameIndex;
    float sampleRate;
    bool played;
    float multiplier;
    std::vector<float> increments;
    float value = 0;
    
public:
    CLinearEnvelope(float _attackDuration,
                    float _decayDuration,
                    float _releaseDuration,
                    float _sustainAmplitude,
                    float _releaseTime);
    virtual ~CLinearEnvelope();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* linear_envelope_hpp */
