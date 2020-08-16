//
//  envelope.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef envelope_hpp
#define envelope_hpp

#include <stdio.h>
#include "signal.hpp"

typedef struct {
    float time_stamp;
    float value;
} CKeyFrame;

class CEnvelope: public CSignal {
    
public:
    CEnvelope();
    virtual ~CEnvelope() = 0;
};

#endif /* envelope_hpp */
