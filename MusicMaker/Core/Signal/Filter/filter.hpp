//
//  Filter.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 20.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef Filter_hpp
#define Filter_hpp

#include <stdio.h>

class CFilter {
public:
    CFilter();
    virtual ~CFilter();
    virtual float filter(float value) = 0;
};

#endif /* Filter_hpp */
