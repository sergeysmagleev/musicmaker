//
//  transport.cpp
//  MusicMaker
//

#include "transport.hpp"
#include <algorithm>
#include <cmath>

namespace MusicMaker {

Transport::Transport(AudioContext context) : context(context) { }

void Transport::setBPM(double bpm) {
    this->bpm = std::max(20.0, std::min(300.0, bpm));
}

double Transport::getBPM() const {
    return bpm;
}

void Transport::start() {
    playing = true;
}

void Transport::stop() {
    playing = false;
}

void Transport::reset() {
    currentSamplePosition = 0;
}

bool Transport::isPlaying() const {
    return playing;
}

uint64_t Transport::samplePosition() const {
    return currentSamplePosition;
}

uint64_t Transport::samplesPerStep() const {
    double samples = (60.0 * context.sampleRate) / (bpm * 4.0);
    return std::max<uint64_t>(1, static_cast<uint64_t>(std::llround(samples)));
}

int Transport::stepForSample(uint64_t samplePosition, int stepCount) const {
    if (stepCount <= 0) {
        return 0;
    }
    return static_cast<int>((samplePosition / samplesPerStep()) % static_cast<uint64_t>(stepCount));
}

void Transport::advance(int frameCount) {
    if (playing && frameCount > 0) {
        currentSamplePosition += static_cast<uint64_t>(frameCount);
    }
}

} // namespace MusicMaker
