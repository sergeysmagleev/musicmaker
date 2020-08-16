//
//  lpf_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef lpf_signal_hpp
#define lpf_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CLowPassFilterSignal: public CSignal {
    CSignal * main_signal;
    float alpha = 0;
    float last_value = 0;
public:
    CLowPassFilterSignal(CSignal * _main_signal, float _alpha);
    virtual ~CLowPassFilterSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* lpf_signal_hpp */
