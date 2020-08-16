//
//  noise_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef noise_wave_hpp
#define noise_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CNoiseWave: public CWave {
protected:
    float shape(float value) override;
public:
    CNoiseWave(float _frequency, float _amplitude, float _phaseShift);
    ~CNoiseWave();
};

#endif /* noise_wave_hpp */
