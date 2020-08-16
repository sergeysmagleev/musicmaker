//
//  LFOTone.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class LFOTone {
    
    private let tone: Tone
    private let lfoFrequency: Float
    private var ampEnvelope: Envelope
    private(set) var startingTime: Float = 0
    private var phase: Float = 0
    private var lfoPhase: Float = 0
    private var played = false
    private let sampleRate: Float
    private var lastValue: Float = 0
    
    private var timeIncrement: Float {
        return 1 / sampleRate
    }
    
    init(tone: Tone, ampEnvelope: Envelope, lfoFrequency: Float, sampleRate: Float) {
        self.tone = tone
        self.ampEnvelope = ampEnvelope
        self.lfoFrequency = lfoFrequency
        self.sampleRate = sampleRate
//        self.envelope.finishedPlayingHandler = { [unowned self] in
//            self.played = false
//        }
    }
    
    func advanceTimeAndReturnValue() -> Float {
        guard played else {
            return 0.0
        }
        lfoPhase += timeIncrement
        while lfoPhase > Float.pi * 2 {
            lfoPhase -= Float.pi * 2
        }
        phase += timeIncrement// * (1 + (sin(Float.pi * 2 * lfoFrequency * lfoPhase) + 1))
        while phase > Float.pi * 2 {
            phase -= Float.pi * 2
        }
        //x = phase
        //y(x) = tone(x) * amp
        let tau: Float = 0.02
        let alpha: Float = abs(sin(Float.pi * 2 * lfoFrequency * lfoPhase)) / 20
        let value = tone.play(time: phase) * ampEnvelope.advanceTimeAndReturnValue()
        lastValue += alpha * (value - lastValue)
        return lastValue
    }
    
    func release() {
//        played = false
//        ampEnvelope.release()
//        freqEnvelope.release()
    }
    
    func start(time: Float) {
        played = true
        startingTime = time
        ampEnvelope.reset()
    }
    
}
