//
//  RecordedTone.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class RecordedTone: Tone {
    
    private(set) var length: Float
    private let tone: Tone
    private let envelope: Envelope
    
    init(tone: Tone, envelope: Envelope, length: Float) {
        self.tone = tone
        self.envelope = envelope
        self.length = length
    }
    
    func play(time: Float) -> Float {
        return tone.play(time: time) * envelope.advanceTimeAndReturnValue()
    }
    
}
