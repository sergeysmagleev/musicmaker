//
//  fft.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 21.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef fft_hpp
#define fft_hpp

#include <stdio.h>
#include <complex>

class CFourierTransform {
    std::complex<float> * buffer;
    std::complex<float> * samples;
    std::complex<float> * w;
    int size;
    int depth;
    void reshuffle_samples(int bucket_size, int left);
public:
    CFourierTransform(int _size);
    ~CFourierTransform();
    void fft(float * _samples);
};

#endif /* fft_hpp */
