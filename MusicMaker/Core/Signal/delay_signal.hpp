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
#include <vector>
#include "signal.hpp"
#include "circular_buffer.hpp"
#include "delay_filter.hpp"
#include <mutex>

class CDelaySignal: public CSignal {
    CSignal * signal;
    float last_value = 0;
    float dry_gain;
    float max_signal = 1.0;
    std::vector<CDelayFilter *> allpass_filters;
    std::vector<CDelayFilter *> comb_filters;
    std::mutex mutex;
public:
    CDelaySignal(CSignal *_signal, float _dry_gain);
    virtual ~CDelaySignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* delay_signal_hpp */
