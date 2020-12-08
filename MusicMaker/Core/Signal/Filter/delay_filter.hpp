//
//  delay_filter.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 22.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef delay_filter_hpp
#define delay_filter_hpp

#include <stdio.h>
#include "filter.hpp"
#include "circular_buffer.hpp"

class CDelayFilter: public CFilter {
protected:
    int delay_length;
    CCircularBuffer<float> buffer;
public:
    CDelayFilter(int _delay_length);
    virtual ~CDelayFilter();
    void reset();
};

#endif /* delay_filter_hpp */
