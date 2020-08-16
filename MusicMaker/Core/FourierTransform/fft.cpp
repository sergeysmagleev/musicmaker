//
//  fft.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 21.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "fft.hpp"
#include "math.h"
#include <stdlib.h>

CFourierTransform::CFourierTransform(int _size) {
    int _depth = (int)truncf(log2f((float)_size));
    size = _size;
    depth = _depth;
    samples = (std::complex<float> *)malloc(_size * sizeof(std::complex<float> *));
    buffer = (std::complex<float> *)malloc(_size * sizeof(std::complex<float> *));
    w = (std::complex<float> *)malloc(_depth * sizeof(std::complex<float> *));
    int level = 2;
    for (int i = 0; i < _depth; ++i) {
        w[i] = pow(M_E, std::complex<float>(0, -1 * M_PI * 2 / level));
        level *= 2;
    }
}

CFourierTransform::~CFourierTransform() {
    free(samples);
    free(buffer);
    free(w);
}

void CFourierTransform::fft(float * _samples) {
    for (int i = 0; i < size; ++i) {
        samples[i] = std::complex<float>(_samples[i]);
    }
    reshuffle_samples(size, 0);
    int buckets = size / 2;
    int bs = 2; // bucket size
    int hbs = 1; // half bucket size
    std::complex<float> *temp = nullptr;
    for (int i = 0; i < depth - 1; ++i) {
        for (int j = 0; j < buckets; ++j) {
            for (int k = 0; k < hbs; ++k) {
                std::complex<float> wk = pow(w[i], (float)(k));
                buffer[bs * j + k] = samples[bs * j + k] + wk * samples[bs * j + k + hbs];
                buffer[bs * j + k + hbs] = samples[bs * j + k] - wk * samples[bs * j + k + hbs];
            }
        }
        buckets /= 2;
        bs *= 2;
        hbs *= 2;
        temp = buffer;
        buffer = samples;
        samples = temp;
    }
    for (int i = 0; i < size; ++i) {
        _samples[i] = abs(samples[i]);
    }
}

void CFourierTransform::reshuffle_samples(int bucket_size, int left) {
    int half_size = bucket_size / 2;
    for (int i = 0; i < half_size; ++i) {
        buffer[left + i] = samples[left + i * 2];
        buffer[left + i + half_size] = samples[left + i * 2 + 1];
    }
    for (int i = left; i < left + bucket_size; ++i) {
        samples[i] = buffer[i];
    }
    if (bucket_size > 4) {
        reshuffle_samples(half_size, left);
        reshuffle_samples(half_size, left + half_size);
    }
}
