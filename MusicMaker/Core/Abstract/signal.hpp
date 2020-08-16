//
//  signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 04.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef signal_hpp
#define signal_hpp

#include <stdio.h>

class CSignal {
public:
    virtual float advanceTimeAndReturnValue(float time_increment) = 0;
    virtual void start() = 0;
    virtual void stop() = 0;
    CSignal();
    virtual ~CSignal();
};

#endif /* signal_hpp */
