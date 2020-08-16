//
//  recorded_track.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "recorded_track.hpp"
#include "math.h"
#include "fft.hpp"

CRecordedTrack::CRecordedTrack(CSignal *_signal, float _length) {
    signal = _signal;
    length = _length;
}

CRecordedTrack::~CRecordedTrack() {
    delete signal;
}

std::vector<float> CRecordedTrack::get_vector_points(int sampleRate) {
    float time_increment = 1.0 / sampleRate;
    int num_of_samples = (int)truncf(length * sampleRate);
    std::vector<float> ret_val;
    ret_val.reserve(num_of_samples);
    signal->start();
    for (int i = 0; i < num_of_samples; ++i) {
        ret_val.push_back(signal->advanceTimeAndReturnValue(time_increment));
    }
    signal->stop();
    return ret_val;
}

float * CRecordedTrack::get_array_points(int sampleRate) {
    float time_increment = 1.0 / sampleRate;
    int num_of_samples = (int)truncf(length * sampleRate);
    float * ret_val = (float *)malloc(sizeof(float) * num_of_samples);
    signal->start();
    for (int i = 0; i < num_of_samples; ++i) {
        float val = signal->advanceTimeAndReturnValue(time_increment);
        ret_val[i] = val;
        printf("%f\r\n", val);
    }
    signal->stop();
    return ret_val;
}

float * CRecordedTrack::get_frequency_analysis(int sampleRate, int number_of_samples) {
    float time_increment = 1.0 / sampleRate;
    float * ret_val = (float *)malloc(sizeof(float) * number_of_samples);
    signal->start();
    for (int i = 0; i < number_of_samples; ++i) {
        float val = signal->advanceTimeAndReturnValue(time_increment);
        ret_val[i] = val;
        printf("%f\r\n", val);
    }
    signal->stop();
    CFourierTransform fft = CFourierTransform(number_of_samples);
    fft.fft(ret_val);
    return ret_val;
}

int CRecordedTrack::get_number_of_samples(int sampleRate) {
    return (int)truncf(length * sampleRate);
}
