//
//  PressedKey.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class PlayedTone {
    
    private let tone: Tone
    private var ampEnvelope: Envelope
    private var freqEnvelope: Envelope
    private(set) var startingTime: Float = 0
    private var phase: Float = 0
    private var played = false
    private let sampleRate: Float
    
    private var timeIncrement: Float {
        return 1 / sampleRate
    }
    
    init(tone: Tone, ampEnvelope: Envelope, freqEnvelope: Envelope, sampleRate: Float) {
        self.tone = tone
        self.ampEnvelope = ampEnvelope
        self.freqEnvelope = freqEnvelope
        self.sampleRate = sampleRate
//        self.envelope.finishedPlayingHandler = { [unowned self] in
//            self.played = false
//        }
    }
    
    func advanceTimeAndReturnValue() -> Float {
        guard played else {
            return 0.0
        }
        phase += timeIncrement //* freqEnvelope.advanceTimeAndReturnValue()
        while phase > Float.pi * 2 {
            phase -= Float.pi * 2
        }
        return tone.play(time: phase) * ampEnvelope.advanceTimeAndReturnValue()
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
        freqEnvelope.reset()
    }
    
}
