//
//  drum_machine.hpp
//  MusicMaker
//

#ifndef drum_machine_hpp
#define drum_machine_hpp

#include <array>
#include "../Audio/audio_context.hpp"
#include "../Audio/transport.hpp"
#include "../DSP/dsp_primitives.hpp"

namespace MusicMaker {

enum class DrumLane : int {
    kick = 0,
    snare = 1,
    hiHat = 2
};

class DrumMachine {
public:
    static constexpr int laneCount = 3;
    static constexpr int stepCount = 64;

    explicit DrumMachine(AudioContext context);

    void setBPM(double bpm);
    double getBPM() const;
    void start();
    void stop();
    void reset();
    bool isPlaying() const;

    void setStep(int lane, int step, bool enabled);
    void toggleStep(int lane, int step);
    bool isStepEnabled(int lane, int step) const;

    float nextSample();
    void render(float *output, int frameCount);

private:
    struct KickVoice {
        explicit KickVoice(AudioContext context);
        void trigger(float velocity);
        float nextSample();
        void reset();

        AudioContext context;
        DSP::ExponentialDecayEnvelope amp;
        double phase = 0.0;
        double ageSamples = 0.0;
        float velocity = 0.0f;
    };

    struct SnareVoice {
        explicit SnareVoice(AudioContext context);
        void trigger(float velocity);
        float nextSample();
        void reset();

        AudioContext context;
        DSP::ExponentialDecayEnvelope amp;
        double tonePhase = 0.0;
        DSP::RandomNoise noise { 0x12345678 };
        float velocity = 0.0f;
    };

    struct HiHatVoice {
        explicit HiHatVoice(AudioContext context);
        void trigger(float velocity);
        float nextSample();
        void reset();

        AudioContext context;
        DSP::ExponentialDecayEnvelope amp;
        DSP::RandomNoise noise { 0x87654321 };
        float previousInput = 0.0f;
        float previousOutput = 0.0f;
        float velocity = 0.0f;
    };

    float renderVoices();
    void triggerLane(int lane);
    void processSequencerForCurrentSample();

    AudioContext context;
    Transport transport;
    std::array<std::array<bool, stepCount>, laneCount> pattern = {};
    int previousStep = -1;
    KickVoice kick;
    SnareVoice snare;
    HiHatVoice hiHat;
};

} // namespace MusicMaker

#endif /* drum_machine_hpp */
