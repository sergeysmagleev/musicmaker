#include "wave.h"
#include <math.h>

float play(CWave *wave, float time, float(*shape)(float value)) {
    float position = (M_PI * 2 * wave->frequency) * time;
    return shape(wave->phaseShift + position) * wave->amplitude;
}

float sine_wave(float value) {
    return sinf(value);
}

float sawtooth_wave(float value) {
    return value / (M_PI * 2);
}

float square_wave(float value) {
    return ((int)(truncf(value / M_PI))) % 2 == 0 ? 1 : -1;
}

void normalize_input(float *value) {
    while (*value > M_PI * 2) {
        *value -= M_PI * 2;
    }
}
