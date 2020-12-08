//
//  CombFilter.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 20.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef CombFilter_hpp
#define CombFilter_hpp

#include <stdio.h>
#include "delay_filter.hpp"

class CCombFilter: public CDelayFilter {
public:
    float filter(float value) override;
    CCombFilter(int _delay_length);
    virtual ~CCombFilter();
};

#endif /* CombFilter_hpp */
