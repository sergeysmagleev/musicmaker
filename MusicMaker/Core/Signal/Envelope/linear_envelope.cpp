//
//  linear_envelope.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "linear_envelope.hpp"

CLinearEnvelope::CLinearEnvelope(float _attackDuration,
                                 float _decayDuration,
                                 float _releaseDuration,
                                 float _sustainAmplitude,
                                 float _releaseTime) : CSignal() {
    attackDuration = _attackDuration;
    decayDuration = _decayDuration;
    releaseDuration = _releaseDuration;
    sustainAmplitude = _sustainAmplitude;
    releaseTime = _releaseTime;
    key_frame_points.push_back({ 0.0, 0.0 });
    key_frame_points.push_back({ attackDuration, 1.0 });
    key_frame_points.push_back({ attackDuration + decayDuration, sustainAmplitude });
    key_frame_points.push_back({ releaseTime, sustainAmplitude });
    key_frame_points.push_back({ releaseTime + releaseDuration, 0.0 });
    for (int i = 1; i < key_frame_points.size(); ++i) {
        increments.push_back((key_frame_points[i].value - key_frame_points[i - 1].value)
        / (key_frame_points[i].time_stamp - key_frame_points[i - 1].time_stamp));
    }
    keyFrameIndex = 0;
    played = false;
    value = 0;
}

CLinearEnvelope::~CLinearEnvelope() {
    key_frame_points.clear();
}

float CLinearEnvelope::advanceTimeAndReturnValue(float time_increment) {
    if (!played) {
        return key_frame_points[key_frame_points.size() - 1].value;
    }
    if (time < 0.0) {
        return 0.0;
    }
    time += time_increment;
    while (keyFrameIndex < 4 && time > key_frame_points[keyFrameIndex + 1].time_stamp) {
        keyFrameIndex += 1;
    }
    if (keyFrameIndex >= 4) {
        played = false;
        return 0.0;
    }
    value += increments[keyFrameIndex] * time_increment;
    return value;
}

void CLinearEnvelope::start() {
    key_frame_points[0].value = value;
    increments[0] = ((key_frame_points[1].value - key_frame_points[0].value)
                     / (key_frame_points[1].time_stamp - key_frame_points[0].time_stamp));
    keyFrameIndex = 0;
    played = true;
    time = 0;
    startingTime = 0;
    latestPlayTime = 0;
}

void CLinearEnvelope::stop() {
    
}
