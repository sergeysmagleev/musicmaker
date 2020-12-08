//
//  linear_continuous_envelope.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "linear_continuous_envelope.hpp"

#define MIN_MAGNITUDE 0.01

CLinearContinuousEnvelope::CLinearContinuousEnvelope(float _attackDuration,
                                                     float _decayDuration,
                                                     float _releaseDuration,
                                                     float _sustainAmplitude) : CSignal() {
    attackDuration = _attackDuration;
    decayDuration = _decayDuration;
    releaseDuration = _releaseDuration;
    sustainAmplitude = _sustainAmplitude;
    releaseTime = 3600;
    sustain_keyframes.push_back({ 0.0, 0.0 });
    sustain_keyframes.push_back({ attackDuration, 1.0 });
    sustain_keyframes.push_back({ attackDuration + decayDuration, sustainAmplitude });
    for (int i = 1; i < sustain_keyframes.size(); ++i) {
        increments.push_back((sustain_keyframes[i].value - sustain_keyframes[i - 1].value)
        / ((sustain_keyframes[i].time_stamp - sustain_keyframes[i - 1].time_stamp)));
    }
    increments.push_back(0);
    keyFrameIndex = 0;
    played = false;
    decrement = sustainAmplitude / releaseDuration;
    released_phase = false;
    value = 0;
}

CLinearContinuousEnvelope::~CLinearContinuousEnvelope() {
    sustain_keyframes.clear();
}

float CLinearContinuousEnvelope::advanceTimeAndReturnValue(float time_increment) {
    if (!played) {
        return 0.0;
    }
    if (time < 0.0) {
        return 0.0;
    }
    mutex.lock();
    time += time_increment;
    if (!released_phase) {
        while (keyFrameIndex < 2 && time > sustain_keyframes[keyFrameIndex + 1].time_stamp) {
            keyFrameIndex += 1;
        }
        if (keyFrameIndex >= 2) {
            mutex.unlock();
            return value;
        }
        value += increments[keyFrameIndex] * time_increment;
        if (value > 1) {
            mutex.unlock();
            return 0.0;
        }
    } else {
        if (value < MIN_MAGNITUDE || time > releaseTime + releaseDuration) {
            played = false;
            value = 0;
            mutex.unlock();
            return 0.0;
        }
        value -= decrement * time_increment;
    }
    mutex.unlock();
    return value;
}

void CLinearContinuousEnvelope::start() {
    mutex.lock();
    sustain_keyframes[0].value = value;
    increments[0] = ((sustain_keyframes[1].value - sustain_keyframes[0].value)
                     / ((sustain_keyframes[1].time_stamp - sustain_keyframes[0].time_stamp)));
    keyFrameIndex = 0;
    time = 0;
    startingTime = 0;
    latestPlayTime = 0;
    released_phase = false;
    played = true;
    mutex.unlock();
}

void CLinearContinuousEnvelope::stop() {
    mutex.lock();
    decrement = value / releaseDuration;
    releaseTime = time;
    released_phase = true;
    mutex.unlock();
}

void CLinearContinuousEnvelope::reset() {
    mutex.lock();
    played = false;
    sustain_keyframes[0].value = 0;
    value = 0;
    keyFrameIndex = 0;
    released_phase = false;
    mutex.unlock();
}
