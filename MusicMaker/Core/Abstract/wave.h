#ifndef wave_h
#define wave_h

#include <stdio.h>

typedef struct {
    float frequency;
    float amplitude;
    float phaseShift;
} CWave;

float play(CWave *wave, float time, float(*shape)(float value));
float sine_wave(float value);
float sawtooth_wave(float value);
float square_wave(float value);
void normalize_input(float *value);

#endif /* wave_h */
