//
//  composed_loop.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 19.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef composed_loop_hpp
#define composed_loop_hpp

#include <stdio.h>
#include <vector>
#include <unordered_map>
#include <string>
#include "signal.hpp"
#include "interval.h"
#include "interval_store.hpp"

class CComposedLoop {
private:
    std::vector<CSignal*> signals;
    CIntervalStore store;
    int bpm = 0;
    int timer = 0;
    int current_beat = 0;
    int increment = 0;
    int length = 0;
    bool current_beat_changed = false;
    void reset_loop();
public:
    CComposedLoop(std::vector<CSignal*> _signals);
    virtual ~CComposedLoop();
    float PlayNextFrame();
    virtual void StartNextBeat();
    void PrepareIntervals();
    void stop();
    void ToggleInterval(int index, uint8_t begin, uint8_t end, std::string _uuid);
    void AddInterval(int index, uint8_t begin, uint8_t end, std::string _uuid);
    void RemoveInterval(int index, std::string _uuid);
    void change_bpm(const int _bpm);
    void set_increment(const int _increment);
//    std::vector<CInterval<uint8_t>> * get_intervals();
};

#endif /* composed_loop_hpp */
