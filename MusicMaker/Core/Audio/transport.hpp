//
//  transport.hpp
//  MusicMaker
//

#ifndef transport_hpp
#define transport_hpp

#include <cstdint>
#include "audio_context.hpp"

namespace MusicMaker {

class Transport {
public:
    explicit Transport(AudioContext context);

    void setBPM(double bpm);
    double getBPM() const;
    void start();
    void stop();
    void reset();
    bool isPlaying() const;
    uint64_t samplePosition() const;
    uint64_t samplesPerStep() const;
    int stepForSample(uint64_t samplePosition, int stepCount) const;
    void advance(int frameCount);

private:
    AudioContext context;
    double bpm = 96.0;
    bool playing = false;
    uint64_t currentSamplePosition = 0;
};

} // namespace MusicMaker

#endif /* transport_hpp */
