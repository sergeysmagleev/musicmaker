//
//  amplified_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef amplified_signal_hpp
#define amplified_signal_hpp

#include <stdio.h>
#include "signal.hpp"

class CAmplifiedSignal: public CSignal {
    CSignal *signal;
    float amplifier;
public:
    CAmplifiedSignal(CSignal *_signal, float _amplifier);
    virtual ~CAmplifiedSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* amplified_signal_hpp */
