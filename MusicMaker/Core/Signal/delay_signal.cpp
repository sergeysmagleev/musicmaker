//
//  delay_signal.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "delay_signal.hpp"
#include <stdlib.h>
#include "math.h"
#include <ctime>

const int comb_delay[] = { 337, 653, 893, 911, 1031, 1113, 1209, 1271,
    1513, 2039, 2177, 2991, 3711, 4201, 6192, 8101, 9113 };
const int comb_delay_max_length = 22;
//const int allpass_delay[] = { 9183, 15309, 23741, 27109 };
const int allpass_delay[] = { 9183, 15309, 23741, 33157 };
const int allpass_delay_max_length = 22;

CDelaySignal::CDelaySignal(CSignal *_signal,
                           int _delay_length,
                           int _num_delays,
                           float _dry_gain) : CSignal() {
    signal = _signal;
    delay_length = _delay_length;
    num_delays = 16;
    num_allpasses = 4;
    if (num_delays > comb_delay_max_length) {
        num_delays = comb_delay_max_length;
    }
    dry_gain = _dry_gain;
    if (dry_gain > 1) {
        dry_gain = 1;
    }
    delay_buffer.alloc_size(40000);
    allpass_buffers = new CCircularBuffer<float>[num_allpasses];
    forward_buffers = new CCircularBuffer<float>[num_allpasses];
    for (int i = 0; i < num_allpasses; ++i) {
        allpass_buffers[i].alloc_size(40000);
        forward_buffers[i].alloc_size(40000);
    }
    past_values = new float[num_delays] {0};
    past_values2 = new float[num_allpasses] {0};
}

CDelaySignal::~CDelaySignal() {
    delete signal;
    delete[] allpass_buffers;
    delete[] forward_buffers;
    delete[] past_values;
    delete[] past_values2;
}

float CDelaySignal::advanceTimeAndReturnValue(float time_increment) {
    
    float value = signal->advanceTimeAndReturnValue(time_increment);
    
    float ret_val = value;
    float part = 0.85 / num_delays;
    float delays = 0;
    float lowpass_factor = 0.5;

    // comb
    for (int i = 0; i < num_delays; ++i) {
        //        ret_val += (*delay_buffer)[delay_length * (i + 1)] * part;
        float delay = delay_buffer[comb_delay[i]] * part;
        delay = past_values[i] + lowpass_factor * (delay - past_values[i]);
        past_values[i] = delay;
        delays += delay;
    }
    
    ret_val += delays;
    delay_buffer.write(ret_val * 0.9);
    delay_buffer.increase_start_index();
    
    // allpass
    float c = 0.7;
    float new_val = 0;
    float norm = 0.5;
    for (int i = 0; i < num_allpasses; ++i) {
        new_val = c * ret_val + allpass_buffers[i][allpass_delay[i]];
        ret_val = ret_val - c * new_val;
        ret_val = past_values2[i] + norm * (ret_val - past_values2[i]);
        past_values2[i] = ret_val;
        norm /= 1.1;
        allpass_buffers[i].write(ret_val);
        allpass_buffers[i].increase_start_index();
    }
    return new_val;
}

float CDelaySignal::allpass(float value, int index) {
    return 0;
}

void CDelaySignal::start() {
    signal->start();
}

void CDelaySignal::stop() {
    signal->stop();
}
