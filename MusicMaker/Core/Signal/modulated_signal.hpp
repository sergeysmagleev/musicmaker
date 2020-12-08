//
//  modulated_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef modulated_signal_hpp
#define modulated_signal_hpp

#include <stdio.h>
#include "signal.hpp"
#include "wave.hpp"

class CModulatedSignal: public CSignal {
    CSignal * main_signal;
    CSignal * amp_modulator = nullptr;
    CSignal * freq_modulator = nullptr;
public:
    CModulatedSignal(CSignal * _main_signal,
                     CSignal * _amp_modulator,
                     CSignal * _freq_modulator);
    CModulatedSignal(CWave * _main_wave,
                     CWave * _amp_modulator_wave,
                     CWave * _freq_modulator_wave);
    CModulatedSignal(CSignal * _main_signal,
                     CWave * _amp_modulator_wave,
                     CWave * _freq_modulator_wave);
    virtual ~CModulatedSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* modulated_signal_hpp */
