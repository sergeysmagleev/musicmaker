//
//  interval_store.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef interval_store_hpp
#define interval_store_hpp

#include <stdio.h>
#include <vector>
#include <unordered_map>
#include <string>
#include "interval.h"

struct CIntervalNode {
    CInterval<uint8_t> interval;
    CIntervalNode *next = nullptr;
    CIntervalNode *prev = nullptr;
};

class CIntervalStore final {
    std::vector<CInterval<uint8_t>> * intervals;
    std::unordered_map<std::string, CInterval<uint8_t>> * interval_dict;
    int * indexes;
    int number_of_instruments;
public:
    CIntervalStore(int _number_of_instruments);
//    CIntervalStore(int _number_of_instruments, std::vector<CInterval<uint8_t>> * intervals);
    ~CIntervalStore();
    void ToggleInterval(int index, CInterval<uint8_t> interval, std::string _uuid);
    void AddInterval(int index, CInterval<uint8_t> interval, std::string _uuid);
    void RemoveInterval(int index, const std::string& _uuid);
    CInterval<uint8_t> CurrentInterval(const int& index);
    CInterval<uint8_t> NextInterval(int index);
    void ResetIntervals();
    void ResetIndexes();
};

#endif /* interval_store_hpp */
