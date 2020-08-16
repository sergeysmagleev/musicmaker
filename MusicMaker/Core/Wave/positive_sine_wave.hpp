//
//  positive_sine_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 06.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef positive_sine_wave_hpp
#define positive_sine_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CPositiveSineWave: public CWave {
    
protected:
    float shape(float value) override;
public:
    CPositiveSineWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CPositiveSineWave();
};


#endif /* positive_sine_wave_hpp */
