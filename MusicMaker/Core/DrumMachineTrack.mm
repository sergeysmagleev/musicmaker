//
//  DrumMachineTrack.mm
//  MusicMaker
//

#import "DrumMachineTrack.h"
#import "drum_machine.hpp"

@implementation DrumMachineTrack {
    MusicMaker::DrumMachine *drumMachine;
}

- (instancetype)initWithSampleRate:(double)sampleRate {
    self = [super init];
    if (self) {
        MusicMaker::AudioContext context;
        context.sampleRate = sampleRate > 0 ? sampleRate : 44100.0;
        context.maxFramesPerBuffer = 512;
        drumMachine = new MusicMaker::DrumMachine(context);
    }
    return self;
}

- (void)dealloc {
    delete drumMachine;
}

- (void)start {
    drumMachine->start();
}

- (void)stop {
    drumMachine->stop();
}

- (void)reset {
    drumMachine->reset();
}

- (void)renderBuffer:(float *)buffer frameCount:(NSInteger)frameCount {
    drumMachine->render(buffer, (int)frameCount);
}

- (void)setBPM:(NSInteger)bpm {
    drumMachine->setBPM((double)bpm);
}

- (void)setStepForInstrument:(NSInteger)instrument beat:(NSInteger)beat active:(BOOL)active {
    drumMachine->setStep((int)instrument, (int)beat, active);
}

- (void)toggleStepForInstrument:(NSInteger)instrument beat:(NSInteger)beat {
    drumMachine->toggleStep((int)instrument, (int)beat);
}

- (BOOL)isStepActiveForInstrument:(NSInteger)instrument beat:(NSInteger)beat {
    return drumMachine->isStepEnabled((int)instrument, (int)beat);
}

@end
