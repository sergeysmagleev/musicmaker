//
//  triangle_wave.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef triangle_wave_hpp
#define triangle_wave_hpp

#include <stdio.h>
#include "wave.hpp"

class CTriangleWave: public CWave {
    float shape(float value) override;
public:
    CTriangleWave(float _frequency, float _amplitude, float _phaseShift);
    virtual ~CTriangleWave();
};

#endif /* triangle_wave_hpp */
