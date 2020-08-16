//
//  delay_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef delay_signal_hpp
#define delay_signal_hpp

#include <stdio.h>
#include "signal.hpp"
#include "circular_buffer.hpp"

class CDelaySignal: public CSignal {
    CSignal * signal;
    int delay_length;
    int num_delays;
    int num_allpasses;
    CCircularBuffer<float> delay_buffer;
    CCircularBuffer<float> *allpass_buffers;
    CCircularBuffer<float> *forward_buffers;
    float * past_values;
    float * past_values2;
    float last_value = 0;
    float allpass(float value, int index);
    float dry_gain;
    float max_signal = 1.0;
public:
    CDelaySignal(CSignal *_signal, int _delay_length, int _num_delays, float _dry_gain);
    virtual ~CDelaySignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* delay_signal_hpp */
