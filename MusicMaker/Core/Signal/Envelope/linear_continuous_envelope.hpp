//
//  linear_continuous_envelope.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef linear_continuous_envelope_hpp
#define linear_continuous_envelope_hpp

#include <stdio.h>
#include <vector>
#include "signal.hpp"
#include "envelope.hpp"
#include <mutex>

class CLinearContinuousEnvelope: public CSignal {
    float startingTime;
    float attackDuration;
    float decayDuration;
    float releaseDuration;
    float sustainAmplitude;
    float releaseTime;
    float latestPlayTime;
    float time;
    std::vector<CKeyFrame> sustain_keyframes;
//    std::vector<CKeyFrame> release_keyframes;
    int keyFrameIndex;
    float sampleRate;
    bool played;
    float multiplier;
    std::vector<float> increments;
    float decrement;
    float value;
    bool released_phase = false;
    std::mutex mutex;
public:
    CLinearContinuousEnvelope(float _attackDuration,
                    float _decayDuration,
                    float _releaseDuration,
                    float _sustainAmplitude);
    virtual ~CLinearContinuousEnvelope();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* linear_continuous_envelope_hpp */
