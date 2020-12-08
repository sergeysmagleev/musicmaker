//
//  combined_signal.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef combined_signal_hpp
#define combined_signal_hpp

#include <stdio.h>
#include <vector>
#include "signal.hpp"

class CCombinedSignal: public CSignal {
    std::vector<CSignal*> signals;
    std::vector<float> amplitudes;
public:
    CCombinedSignal(std::vector<CSignal*> _signals);
    CCombinedSignal(std::vector<CSignal*> _signals, std::vector<float> _amplitudes);
    virtual ~CCombinedSignal();
    float advanceTimeAndReturnValue(float time_increment) override;
    void start() override;
    void stop() override;
    void reset() override;
};

#endif /* combined_signal_hpp */
