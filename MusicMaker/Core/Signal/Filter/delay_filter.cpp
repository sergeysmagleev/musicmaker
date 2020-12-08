//
//  delay_filter.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 22.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "delay_filter.hpp"

CDelayFilter::CDelayFilter(int _delay_length) : CFilter() {
    delay_length = _delay_length;
    buffer.alloc_size(_delay_length + 1);
}

CDelayFilter::~CDelayFilter() { }

void CDelayFilter::reset() {
    buffer.clear_and_reset(0);
}
