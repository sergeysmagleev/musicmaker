//
//  drum_machine.cpp
//  MusicMaker
//

#include "drum_machine.hpp"
#include <cmath>

namespace MusicMaker {

DrumMachine::KickVoice::KickVoice(AudioContext context) : context(context) { }

void DrumMachine::KickVoice::trigger(float velocity) {
    this->velocity = velocity;
    phase = 0.0;
    ageSamples = 0.0;
    amp.trigger(0.22, context.sampleRate);
}

float DrumMachine::KickVoice::nextSample() {
    if (!amp.isActive()) {
        return 0.0f;
    }
    double ageSeconds = ageSamples / context.sampleRate;
    double pitch = 42.0 + 100.0 * std::exp(-ageSeconds * 32.0);
    phase += DSP::twoPi * pitch / context.sampleRate;
    if (phase >= DSP::twoPi) {
        phase -= DSP::twoPi;
    }
    ageSamples += 1.0;
    return static_cast<float>(std::sin(phase)) * amp.next() * velocity * 0.95f;
}

void DrumMachine::KickVoice::reset() {
    amp.reset();
    phase = 0.0;
    ageSamples = 0.0;
    velocity = 0.0f;
}

DrumMachine::SnareVoice::SnareVoice(AudioContext context) : context(context) { }

void DrumMachine::SnareVoice::trigger(float velocity) {
    this->velocity = velocity;
    tonePhase = 0.0;
    amp.trigger(0.14, context.sampleRate);
}

float DrumMachine::SnareVoice::nextSample() {
    if (!amp.isActive()) {
        return 0.0f;
    }
    tonePhase += DSP::twoPi * 185.0 / context.sampleRate;
    if (tonePhase >= DSP::twoPi) {
        tonePhase -= DSP::twoPi;
    }
    float tone = static_cast<float>(std::sin(tonePhase)) * 0.35f;
    float noiseSample = noise.nextBipolar() * 0.65f;
    return (tone + noiseSample) * amp.next() * velocity * 0.7f;
}

void DrumMachine::SnareVoice::reset() {
    amp.reset();
    tonePhase = 0.0;
    velocity = 0.0f;
}

DrumMachine::HiHatVoice::HiHatVoice(AudioContext context) : context(context) { }

void DrumMachine::HiHatVoice::trigger(float velocity) {
    this->velocity = velocity;
    previousInput = 0.0f;
    previousOutput = 0.0f;
    amp.trigger(0.055, context.sampleRate);
}

float DrumMachine::HiHatVoice::nextSample() {
    if (!amp.isActive()) {
        return 0.0f;
    }
    float input = noise.nextBipolar();
    float output = 0.78f * (previousOutput + input - previousInput);
    previousInput = input;
    previousOutput = output;
    return output * amp.next() * velocity * 0.45f;
}

void DrumMachine::HiHatVoice::reset() {
    amp.reset();
    previousInput = 0.0f;
    previousOutput = 0.0f;
    velocity = 0.0f;
}

DrumMachine::DrumMachine(AudioContext context)
    : context(context), transport(context), kick(context), snare(context), hiHat(context) { }

void DrumMachine::setBPM(double bpm) {
    transport.setBPM(bpm);
}

double DrumMachine::getBPM() const {
    return transport.getBPM();
}

void DrumMachine::start() {
    previousStep = -1;
    transport.start();
}

void DrumMachine::stop() {
    transport.stop();
    kick.reset();
    snare.reset();
    hiHat.reset();
}

void DrumMachine::reset() {
    transport.reset();
    previousStep = -1;
    kick.reset();
    snare.reset();
    hiHat.reset();
}

bool DrumMachine::isPlaying() const {
    return transport.isPlaying();
}

void DrumMachine::setStep(int lane, int step, bool enabled) {
    if (lane < 0 || lane >= laneCount || step < 0 || step >= stepCount) {
        return;
    }
    pattern[lane][step] = enabled;
}

void DrumMachine::toggleStep(int lane, int step) {
    if (lane < 0 || lane >= laneCount || step < 0 || step >= stepCount) {
        return;
    }
    pattern[lane][step] = !pattern[lane][step];
}

bool DrumMachine::isStepEnabled(int lane, int step) const {
    if (lane < 0 || lane >= laneCount || step < 0 || step >= stepCount) {
        return false;
    }
    return pattern[lane][step];
}

float DrumMachine::nextSample() {
    if (!transport.isPlaying()) {
        return 0.0f;
    }
    processSequencerForCurrentSample();
    float sample = renderVoices();
    transport.advance(1);
    return sample;
}

void DrumMachine::render(float *output, int frameCount) {
    if (output == nullptr || frameCount <= 0) {
        return;
    }
    for (int i = 0; i < frameCount; ++i) {
        output[i] = nextSample();
    }
}

float DrumMachine::renderVoices() {
    float sample = kick.nextSample() + snare.nextSample() + hiHat.nextSample();
    return DSP::softLimit(sample);
}

void DrumMachine::triggerLane(int lane) {
    switch (lane) {
        case static_cast<int>(DrumLane::kick):
            kick.trigger(1.0f);
            break;
        case static_cast<int>(DrumLane::snare):
            snare.trigger(0.95f);
            break;
        case static_cast<int>(DrumLane::hiHat):
            hiHat.trigger(0.85f);
            break;
        default:
            break;
    }
}

void DrumMachine::processSequencerForCurrentSample() {
    int step = transport.stepForSample(transport.samplePosition(), stepCount);
    if (step == previousStep) {
        return;
    }
    previousStep = step;
    for (int lane = 0; lane < laneCount; ++lane) {
        if (pattern[lane][step]) {
            triggerLane(lane);
        }
    }
}

} // namespace MusicMaker
