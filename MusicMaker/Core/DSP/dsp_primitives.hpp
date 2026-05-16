//
//  dsp_primitives.hpp
//  MusicMaker
//

#ifndef dsp_primitives_hpp
#define dsp_primitives_hpp

#include <algorithm>
#include <cmath>
#include <cstdint>

namespace MusicMaker::DSP {

constexpr double twoPi = 6.28318530717958647692;

class ExponentialDecayEnvelope {
public:
    void trigger(double decaySeconds, double sampleRate) {
        value = 1.0f;
        double samples = std::max(1.0, decaySeconds * sampleRate);
        multiplier = static_cast<float>(std::exp(std::log(0.001) / samples));
        active = true;
    }

    float next() {
        if (!active) {
            return 0.0f;
        }

        float output = value;
        value *= multiplier;
        if (value < 0.0005f) {
            reset();
        }
        return output;
    }

    bool isActive() const {
        return active;
    }

    void reset() {
        value = 0.0f;
        multiplier = 0.0f;
        active = false;
    }

private:
    float value = 0.0f;
    float multiplier = 0.0f;
    bool active = false;
};

class RandomNoise {
public:
    explicit RandomNoise(uint32_t seed) : state(seed) { }

    float nextBipolar() {
        state = state * 1664525u + 1013904223u;
        float normalized = static_cast<float>((state >> 8) & 0x00FFFFFF) / static_cast<float>(0x00FFFFFF);
        return normalized * 2.0f - 1.0f;
    }

    void reset(uint32_t seed) {
        state = seed;
    }

private:
    uint32_t state;
};

inline float softLimit(float value) {
    return value / (1.0f + std::fabs(value));
}

inline float clampAudio(float value) {
    return std::max(-1.0f, std::min(1.0f, value));
}

} // namespace MusicMaker::DSP

#endif /* dsp_primitives_hpp */
