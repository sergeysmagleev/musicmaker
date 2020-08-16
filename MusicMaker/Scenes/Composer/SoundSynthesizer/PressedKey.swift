//
//  PressedKey.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class PlayedTone: Tone {
    
    private let tone: Tone
    private let envelope: Envelope
    private var startingTime: Double = 0
    
    init(tone: Tone, envelope: Envelope) {
        self.tone = tone
        self.envelope = envelope
    }
    
    func play(time: Double) -> Double {
        return tone.play(time: time) * envelope.amplifier(at: time)
    }
    
    func release() {
        envelope.release()
    }
    
    func start(time: Double) {
        startingTime = time
        envelope.reset(to: startingTime)
    }
    
}
