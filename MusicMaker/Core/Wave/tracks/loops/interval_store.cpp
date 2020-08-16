//
//  interval_store.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "interval_store.hpp"

#warning WIP not finished

template <typename T>
bool sort_comparator(CInterval<T> left, CInterval<T> right) {
    return left.start < right.start;
}
template bool sort_comparator<uint8_t>(CInterval<uint8_t>, CInterval<uint8_t>);

CIntervalStore::CIntervalStore(int _number_of_instruments) {
    number_of_instruments = _number_of_instruments;
    indexes = new int[number_of_instruments];
    intervals = new std::vector<CInterval<uint8_t>>[number_of_instruments];
    interval_dict = new std::unordered_map<std::string, CInterval<uint8_t>>[number_of_instruments];
}

CIntervalStore::~CIntervalStore() {
    for (int i = 0; i < number_of_instruments; ++i) {
        intervals[i].clear();
        interval_dict[i].clear();
    }
    delete[] intervals;
    delete[] interval_dict;
    delete[] indexes;
}

void CIntervalStore::ToggleInterval(int index, CInterval<uint8_t> interval, std::string _uuid) {
    if (interval_dict[index].find(_uuid) != interval_dict[index].end()) {
        RemoveInterval(index, _uuid);
    } else {
        AddInterval(index, interval, _uuid);
    }
}

void CIntervalStore::AddInterval(int index, CInterval<uint8_t> interval, std::string _uuid) {
    interval_dict[index].insert({ _uuid, interval });
}

void CIntervalStore::RemoveInterval(int index, const std::string& _uuid) {
    interval_dict[index].erase(_uuid);
}

CInterval<uint8_t> CIntervalStore::CurrentInterval(const int& index) {
    if (indexes[index] < intervals[index].size()) {
        return intervals[index][indexes[index]];
    }
    return { 255, 255 };
}

CInterval<uint8_t> CIntervalStore::NextInterval(int index) {
    if (++indexes[index] < intervals[index].size()) {
        return intervals[index][indexes[index]];
    }
    return { 255, 255 };
}

void CIntervalStore::ResetIntervals() {
    for (int i = 0; i < number_of_instruments; ++i) {
        intervals[i].clear();
        for (const auto &interval_pair: interval_dict[i]) {
            intervals[i].push_back(interval_pair.second);
        }
        std::sort(intervals[i].begin(), intervals[i].end(), sort_comparator<uint8_t>);
        indexes[i] = 0;
    }
}

void CIntervalStore::ResetIndexes() {
    for (int i = 0; i < number_of_instruments; ++i) {
        indexes[i] = 0;
    }
}
