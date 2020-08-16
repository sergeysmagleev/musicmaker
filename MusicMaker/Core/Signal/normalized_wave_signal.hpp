//
//  normalized_wave_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef normalized_wave_signal_hpp
#define normalized_wave_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CNormalizedWaveSignal: public CSignal {
    CSignal *signal;
public:
    CNormalizedWaveSignal(CSignal * _signal);
    virtual ~CNormalizedWaveSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
};

#endif /* normalized_wave_signal_hpp */
