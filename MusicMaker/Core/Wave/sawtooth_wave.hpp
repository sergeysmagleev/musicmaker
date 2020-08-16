//
//  sawtooth_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 01.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef sawtooth_wave_hpp
#define sawtooth_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CSawtoothWave: public CWave {
    float shape(float value) override;
public:
    CSawtoothWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CSawtoothWave();
};

#endif /* sawtooth_wave_hpp */
