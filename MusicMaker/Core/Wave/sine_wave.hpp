//
//  sine_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef sine_wave_hpp
#define sine_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CSineWave: public CWave {
    
protected:
    float shape(float value) override;
public:
    CSineWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CSineWave();
};

#endif /* sine_wave_hpp */
