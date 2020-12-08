//
//  AllpassFilter.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 20.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "allpass_filter.hpp"

float CAllpassFilter::filter(float value) {
    float c = 0.75;
    float new_val = value + c * buffer[delay_length];
    buffer.write(new_val);
    new_val = -c * new_val + buffer[delay_length];
    buffer.increase_start_index();
    return new_val;
}

CAllpassFilter::CAllpassFilter(int _delay_length) : CDelayFilter(_delay_length) { }
CAllpassFilter::~CAllpassFilter() { }
