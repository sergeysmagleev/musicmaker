//
//  circular_buffer.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 08.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef circular_buffer_hpp
#define circular_buffer_hpp

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <mutex>
#include <cstring>

/// Warning: not thread safe!

template <class T>
class CCircularBuffer {
    T* buffer = nullptr;
    int start_index = 0;
    int buffer_size = 0;
public:
    CCircularBuffer() { alloc_size(1); }
    
    CCircularBuffer(int size) { alloc_size(size); }
    
    ~CCircularBuffer() {
        if (buffer != nullptr) {
            delete[] buffer;
        }
    }
    
    void alloc_size(int size) {
        if (buffer != nullptr) {
            delete[] buffer;
        }
        buffer = new T[size] { 0 };
        buffer_size = size;
    }
    
    T operator[] (int index) {
        assert(buffer != nullptr);
        assert(start_index < buffer_size && start_index >= 0);
        assert(buffer_size > 0);
        int normalized_index = start_index - index;
        if (normalized_index < 0) {
            normalized_index += buffer_size;
        }
        return buffer[normalized_index];
    }
    
    void write(T element) {
        assert(buffer != nullptr);
        assert(start_index < buffer_size && start_index >= 0);
        buffer[start_index] = element;
    }
    
    void increase_start_index() {
        if (++start_index >= buffer_size) {
            start_index = 0;
        }
    }
    
    void clear_and_reset(T null_value) {
        assert(buffer != nullptr);
        for (int i = 0; i < buffer_size; ++i) {
            buffer[i] = 0;
        }
//        start_index = 0;
    }
    
    const T * to_linear_buffer() {
        return buffer;
    }
    
};

#endif /* circular_buffer_hpp */
