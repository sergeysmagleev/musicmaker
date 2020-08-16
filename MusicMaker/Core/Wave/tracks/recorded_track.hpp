//
//  recorded_track.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef recorded_track_hpp
#define recorded_track_hpp

#include <stdio.h>
#include <vector>
#include "signal.hpp"

class CRecordedTrack {
    CSignal *signal;
    float length;
public:
    CRecordedTrack(CSignal *_signal, float _length);
    virtual ~CRecordedTrack();
    std::vector<float> get_vector_points(int sampleRate);
    float *get_array_points(int sampleRate);
    float *get_frequency_analysis(int sampleRate, int number_of_samples);
    int get_number_of_samples(int sampleRate);
};

#endif /* recorded_track_hpp */
