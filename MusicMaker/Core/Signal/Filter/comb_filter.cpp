//
//  CombFilter.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 20.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "comb_filter.hpp"

float CCombFilter::filter(float value) {
    float c = 0.75;
    float lowpass_factor = 0.75;
    float delay = value * c - lowpass_factor * buffer[delay_length];
    buffer.write(delay);
    buffer.increase_start_index();
    return delay;
}

CCombFilter::CCombFilter(int _delay_length) : CDelayFilter(_delay_length) { }
CCombFilter::~CCombFilter() { }
