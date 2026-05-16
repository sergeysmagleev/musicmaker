//
//  audio_context.hpp
//  MusicMaker
//

#ifndef audio_context_hpp
#define audio_context_hpp

namespace MusicMaker {

struct AudioContext {
    double sampleRate = 44100.0;
    int maxFramesPerBuffer = 512;
};

} // namespace MusicMaker

#endif /* audio_context_hpp */
