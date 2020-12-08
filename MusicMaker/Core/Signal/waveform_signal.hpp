//
//  waveform_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef waveform_signal_hpp
#define waveform_signal_hpp

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "signal.hpp"
#include "wave.hpp"

class CWaveformSignal: public CSignal {
    std::vector<CWave*> waves;
    std::vector<float> amplitudes;
    float mltplr;
public:
    CWaveformSignal(std::vector<CWave*> _waves, std::vector<float> _amplitudes);
    CWaveformSignal(CWave *wave);
    virtual ~CWaveformSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* waveform_signal_hpp */
