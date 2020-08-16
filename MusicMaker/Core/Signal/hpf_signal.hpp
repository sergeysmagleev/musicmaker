//
//  hpf_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef hpf_signal_hpp
#define hpf_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CHighPassFilterSignal: public CSignal {
    CSignal * main_signal;
    float alpha;
    float previous_x = 0;
    float previous_y = 0;
public:
    CHighPassFilterSignal(CSignal * _main_signal, float _alpha);
    virtual ~CHighPassFilterSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* hpf_signal_hpp */
