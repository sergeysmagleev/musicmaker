//
//  wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef wave_hpp
#define wave_hpp

#include <stdio.h>

class CWave {
protected:
    float frequency;
    float amplitude;
    float phaseShift;
    float phase;
    virtual float shape(float value) = 0;
    
public:
    CWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CWave();
    virtual float play(float time);
    virtual void reset();
};

#endif /* wave_hpp */
