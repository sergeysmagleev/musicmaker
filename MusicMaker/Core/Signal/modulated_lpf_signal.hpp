//
//  modulated_lpf_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 02.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef modulated_lpf_signal_hpp
#define modulated_lpf_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CModulatedLPFSignal: public CSignal {
    CSignal * main_signal;
    CSignal * modulating_signal;
    float last_value = 0;
    bool negative = false;
public:
    CModulatedLPFSignal(CSignal * _main_signal,
                        CSignal * _modulating_signal,
                        bool _negative = true);
    virtual ~CModulatedLPFSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* modulated_lpf_signal_hpp */
