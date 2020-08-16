//
//  square_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef square_wave_hpp
#define square_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CSquareWave: public CWave {
    float shape(float value) override;
public:
    CSquareWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CSquareWave();
};

#endif /* square_wave_hpp */
