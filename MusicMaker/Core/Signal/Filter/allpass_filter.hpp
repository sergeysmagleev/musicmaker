//
//  AllpassFilter.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 20.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef AllpassFilter_hpp
#define AllpassFilter_hpp

#include <stdio.h>
#include "delay_filter.hpp"

class CAllpassFilter: public CDelayFilter {
public:
    float filter(float value) override;
    CAllpassFilter(int _delay_length);
    virtual ~CAllpassFilter();
};

#endif /* AllpassFilter_hpp */
