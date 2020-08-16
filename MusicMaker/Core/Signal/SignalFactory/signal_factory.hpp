//
//  signal_factory.hpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#ifndef signal_factory_hpp
#define signal_factory_hpp

#include <stdio.h>
#include "signal.hpp"

class CSignalFactory {
    
    
    
public:
    static CSignal *kick_main(float frequency);
    static CSignal *kick_noise(float frequency);
    static CSignal *snare_main();
    static CSignal *snare_transient();
    static CSignal *snare_noise();
    
    static CSignal *kickDrum(float frequency);
    static CSignal *snareDrum();
    static CSignal *sawtooth(float frequency);
    static CSignal *short_noise();
    static CSignal *hihat_drum();
    static CSignal *phat_bass();
    
    static CSignal *modulated_bass(float frequency, float subfrequency);
    static CSignal *hi_noise();
    static CSignal *synth_string(float frequency);
    static CSignal *reverb_string(float frequency);
    static CSignal *chord(float frequency1, float frequency2, float frequency3);
    static CSignal *separate_reverb_chord(float frequency1, float frequency2, float frequency3);
    static CSignal *single_reverb_chord(float frequency1, float frequency2, float frequency3);
    static CSignal *bell_thingy(float frequency);
    
    static CSignal *quick_noise();
};

#endif /* signal_factory_hpp */
