//
//  signal_factory.cpp
//  MusicMaker
//
//  Created by Sergey Smagleev on 09.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

#include "signal_factory.hpp"

#include "sine_wave.hpp"
#include "noise_wave.hpp"
#include "triangle_wave.hpp"
#include "square_wave.hpp"
#include "sawtooth_wave.hpp"
#include "positive_sine_wave.hpp"

#include "waveform_signal.hpp"
#include "modulated_signal.hpp"
#include "amplified_signal.hpp"
#include "combined_signal.hpp"

#include "lpf_signal.hpp"
#include "hpf_signal.hpp"
#include "modulated_lpf_signal.hpp"
#include "delay_signal.hpp"

#include "linear_envelope.hpp"
#include "linear_continuous_envelope.hpp"

CSignal *CSignalFactory::kick_main(float frequency) {
    CWave * sine_wave = new CSineWave(frequency, 1.0, 0.0);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.15, 0.15, 1.0, 0.156);
    CLinearEnvelope * freq_envelope = new CLinearEnvelope(0.005, 0.05, 0.3, 0.2, 0.06);
    CSignal *sine_signal = new CWaveformSignal({sine_wave}, { 0.8 });
    CSignal *sine_modulated_signal = new CModulatedSignal(sine_signal, amp_envelope, freq_envelope);
    return sine_modulated_signal;
}

CSignal *CSignalFactory::kick_noise(float frequency) {
    CWave * noise_wave = new CNoiseWave(frequency, 1.0, 0.0);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.01, 0.01, 0.03, 0.3, 0.021);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 0.1 });
    CSignal *noise_modulated_signal = new CModulatedSignal(noise_signal, amp_envelope, nullptr);
    CSignal *lpf_noise = new CHighPassFilterSignal(noise_modulated_signal, 0.9);
    return lpf_noise;
}

CSignal *CSignalFactory::snare_main() {
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.05, 0.1, 0.2, 0.06);
    CWave *sine_wave = new CSineWave(198, 1.0, 0.0);
    CWaveformSignal *sine_signal = new CWaveformSignal(sine_wave);
    CModulatedSignal *sine_modulated_signal = new CModulatedSignal(sine_signal, amp_envelope, nullptr);
    return sine_modulated_signal;
}

CSignal *CSignalFactory::snare_transient() {
    CWave *triangle_wave = new CTriangleWave(302, 1.0, 0);
    CWave *sawtooth_wave= new CSawtoothWave(156, 0.5, 0);
    CSignal *modulated_signal = new CModulatedSignal(triangle_wave, nullptr, sawtooth_wave);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.01, 0.05, 0.2, 0.016);
    CLinearEnvelope * freq_envelope = new CLinearEnvelope(0.005, 0.01, 0.05, 0.8, 0.1);
    CSignal *transient = new CModulatedSignal(modulated_signal, amp_envelope, freq_envelope);
    return transient;
}
                                                  
CSignal *CSignalFactory::snare_noise() {
    CWave * noise_wave = new CNoiseWave(440, 1.0, 0.0);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.075, 0.2, 0.2, 0.081);
    CSignal *noise_signal = new CWaveformSignal({ noise_wave }, { 0.5 });
    CHighPassFilterSignal *hpf_noise = new CHighPassFilterSignal(noise_signal, 0.8);
    CLowPassFilterSignal *lpf_noise = new CLowPassFilterSignal(hpf_noise, 0.6);
    CSignal *noise_modulated_signal = new CModulatedSignal(lpf_noise, amp_envelope, nullptr);
    return noise_modulated_signal;
}

CSignal *CSignalFactory::kickDrum(float frequency) {
    CSignal *combined = new CCombinedSignal({
        CSignalFactory::kick_main(frequency),
        CSignalFactory::kick_noise(frequency),
        CSignalFactory::short_noise()
    }, {
        1.0,
        0.2,
        0.1
    });
    CAmplifiedSignal *amplified = new CAmplifiedSignal(combined, 0.6);
    return amplified;
}

CSignal *CSignalFactory::snareDrum() {
    CCombinedSignal *combo2 = new CCombinedSignal({
        CSignalFactory::snare_noise(),
        CSignalFactory::short_noise(),
        CSignalFactory::snare_main(),
        CSignalFactory::snare_transient()
    }, {
        0.1,
        0.2,
        1.0,
        0.8
    });
    CSignal *hipass = new CHighPassFilterSignal(combo2, 0.9);
    CSignal *amplified = new CAmplifiedSignal(hipass, 1.5);
    return amplified;
}

CSignal *CSignalFactory::sawtooth(float frequency) {
    CWave *wave1 = new CSawtoothWave(302, 1.0, 0);
    CWave *wave2 = new CTriangleWave(150, 1.0, 0);
    CSignal *mod1 = new CModulatedSignal(wave1, nullptr, wave2);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.01, 0.05, 0.2, 0.016);
    CSignal *modulated = new CModulatedSignal(mod1, amp_envelope, nullptr);
    return modulated;
}

CSignal *CSignalFactory::short_noise() {
    CWave * noise_wave = new CNoiseWave(440, 1.0, 0.0);
    CLinearEnvelope * noise_amp_envelope = new CLinearEnvelope(0.01, 0.01, 0.03, 0.3, 0.021);
    CLinearEnvelope * freq_envelope = new CLinearEnvelope(0.01, 0.01, 0.03, 0.3, 0.021);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 1.0 });
    CSignal *modulated_lpf_noise = new CModulatedLPFSignal(noise_signal, freq_envelope);
    CSignal *noise_modulated_signal = new CModulatedSignal(modulated_lpf_noise, noise_amp_envelope, nullptr);
    return noise_modulated_signal;
}

CSignal *CSignalFactory::hihat_drum() {
    CWave * noise_wave = new CNoiseWave(440, 1.0, 0.0);
    CLinearEnvelope * noise_amp_envelope = new CLinearEnvelope(0.005, 0.01, 0.1, 0.3, 0.015);
    CLinearEnvelope * freq_envelope = new CLinearEnvelope(0.01, 0.01, 0.01, 0.3, 0.021);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 0.5 });
    CSignal *modulated_lpf_noise = new CModulatedLPFSignal(noise_signal, freq_envelope);
    CSignal *noise_modulated_signal = new CModulatedSignal(modulated_lpf_noise, noise_amp_envelope, nullptr);
    CSignal *hi_filter = new CHighPassFilterSignal(noise_modulated_signal, 0.1);
    return hi_filter;
}

CSignal *CSignalFactory::phat_bass() {
    CWave * sin_wave = new CSineWave(440, 1.0, 0.0);
    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.15, 0.15, 1.0, 0.156);
    CLinearEnvelope * freq_envelope = new CLinearEnvelope(0.005, 0.05, 0.3, 0.2, 0.06);
    CSignal *sine_signal = new CWaveformSignal({sin_wave}, { 0.8 });
    CSignal *sine_modulated_signal = new CModulatedSignal(sine_signal, amp_envelope, freq_envelope);
    return sine_modulated_signal;
}

CSignal *CSignalFactory::modulated_bass(float frequency, float subfrequency) {
    CWave * noise_wave = new CTriangleWave(frequency, 1.0, 0.0);
    CWave * sine_normal = new CSineWave(subfrequency, 1.0, 0.0);
    CLinearContinuousEnvelope * noise_amp_envelope = new CLinearContinuousEnvelope(0.1, 0.1, 0.3, 0.7);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 1.0 });
    CSignal *sine_normal_signal = new CWaveformSignal({sine_normal}, { 1.0 });
    CWave *sine = new CPositiveSineWave(4, 0.95, 0.0);
    CWave *sine2 = new CPositiveSineWave(2, 0.9, 0.0);
    CSignal *sine_signal = new CWaveformSignal({sine}, { 1.0 });
    CSignal *sine_signal2 = new CWaveformSignal({sine2}, { 1.0 });
    CSignal *modulated = new CModulatedLPFSignal(noise_signal, sine_signal);
    CSignal *modulated2 = new CModulatedLPFSignal(modulated, sine_signal2);
    CSignal *total = new CCombinedSignal({modulated2, sine_normal_signal}, {0.9, 0.1});
    CSignal *noise_modulated_signal = new CModulatedSignal(total, noise_amp_envelope, nullptr);
    CSignal *amplified = new CAmplifiedSignal(noise_modulated_signal, 2.0);
    return amplified;
}

CSignal *CSignalFactory::hi_noise() {
    CWave * noise_wave = new CNoiseWave(4400, 1.0, 0.0);
    CLinearEnvelope * noise_amp_envelope = new CLinearEnvelope(0.005, 0.01, 0.1, 0.3, 0.015);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 0.5 });
    CSignal *noise_modulated_signal = new CModulatedSignal(noise_signal, noise_amp_envelope, nullptr);
    return noise_modulated_signal;
}

CSignal *CSignalFactory::synth_string(float frequency) {
    CWave * wave = new CSawtoothWave(frequency, 0.5, 0.0);
    int detune = (int)(frequency / 100);
    CWave * another_wave = new CSawtoothWave(frequency - detune, 0.2, 0.0);
    CLinearContinuousEnvelope * noise_amp_envelope = new CLinearContinuousEnvelope(2.0, 1.0, 0.4, 0.7);
    CSignal *noise_signal = new CWaveformSignal({wave, another_wave}, { 0.7, 0.7 });
    CWave *sine = new CPositiveSineWave(0.25, 0.8, 0.0);
    CSignal *modulating_signal = new CWaveformSignal({sine}, {0.8});
    CSignal *low_pass = new CModulatedLPFSignal(noise_signal, modulating_signal, true);
    CSignal *noise_modulated_signal = new CModulatedSignal(low_pass, noise_amp_envelope, nullptr);
    return noise_modulated_signal;
}

CSignal *CSignalFactory::reverb_string(float frequency) {
    CSignal *synth = CSignalFactory::synth_string(frequency);
    CSignal *delayed = new CDelaySignal(synth, 2077, 20, 0.0);
    return delayed;
}

//CSignal *delayed = new CDelaySignal(synth, 1577, 25); <-- golden ratio

CSignal *CSignalFactory::chord(float frequency1, float frequency2, float frequency3) {
    CSignal *signal1 = synth_string(frequency1);
    CSignal *signal2 = synth_string(frequency2);
    CSignal *signal3 = synth_string(frequency3);
    CSignal *combined = new CCombinedSignal({signal1, signal2, signal3}, {0.3, 0.3, 0.3});
    CSignal *amplified = new CAmplifiedSignal(combined, 0.8);
    return amplified;
}

CSignal *CSignalFactory::separate_reverb_chord(float frequency1, float frequency2, float frequency3) {
    CSignal *signal1 = reverb_string(frequency1);
    CSignal *signal2 = reverb_string(frequency2);
    CSignal *signal3 = reverb_string(frequency3);
    CSignal *combined = new CCombinedSignal({signal1, signal2, signal3}, {0.3, 0.3, 0.3});
    CSignal *amplified = new CAmplifiedSignal(combined, 0.4);
    CSignal *hpf = new CHighPassFilterSignal(amplified, 0.92);
    return hpf;
}

CSignal *CSignalFactory::single_reverb_chord(float frequency1, float frequency2, float frequency3) {
    CSignal *signal1 = synth_string(frequency1);
    CSignal *signal2 = synth_string(frequency2);
    CSignal *signal3 = synth_string(frequency3);
    CSignal *combined = new CCombinedSignal({signal1, signal2, signal3}, {0.3, 0.3, 0.3});
    CSignal *delayed = new CDelaySignal(combined, 1283, 17, 0.6);
    CSignal *amplified = new CAmplifiedSignal(delayed, 0.05);
    return amplified;
}

CSignal *CSignalFactory::bell_thingy(float frequency) {
    CWave * wave1 = new CSineWave(frequency, 1.0, 0.0);
    CWave * wave3 = new CSineWave(frequency * 3, 1.0, 0.0);
    CWave * wave5 = new CSineWave(frequency * 8, 1.0, 0.0);

    CLinearEnvelope * amp_envelope = new CLinearEnvelope(0.005, 0.05, 0.2, 0.3, 0.06);
    CWaveformSignal *signal = new CWaveformSignal({ wave1, wave3, wave5 }, { 1.0, 0.2, 0.6 });
    
    CModulatedSignal *modulated = new CModulatedSignal(signal, amp_envelope, nullptr);
    
    CLowPassFilterSignal *wave_lowpass = new CLowPassFilterSignal(modulated, 0.5);
    CHighPassFilterSignal *wave_highpass = new CHighPassFilterSignal(wave_lowpass, 0.8);
    CSignal *delayed = new CDelaySignal(wave_highpass, 1007, 9, 0.5);
    return delayed;
}

CSignal *CSignalFactory::quick_noise() {
    CWave * noise_wave = new CNoiseWave(0, 1.0, 0.0);
    CLinearEnvelope * noise_amp_envelope = new CLinearEnvelope(0.01, 0.02, 0.1, 0.3, 0.031);
    CSignal *noise_signal = new CWaveformSignal({noise_wave}, { 1.0 });
    CSignal *noise_modulated_signal = new CModulatedSignal(noise_signal, noise_amp_envelope, nullptr);
    CSignal *delayed = new CDelaySignal(noise_modulated_signal, 1007, 9, 0.5);
    return delayed;
}
