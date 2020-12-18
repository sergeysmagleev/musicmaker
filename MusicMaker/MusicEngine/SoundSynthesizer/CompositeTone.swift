//
//  CompositeTone.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class CompositeTone {
    
    private let tones: [PlayedTone]
    private let sampleRate: Float
    
    private var timeIncrement: Float {
        return 1 / sampleRate
    }
    
    init(tones: [PlayedTone], sampleRate: Float) {
        self.tones = tones
        self.sampleRate = sampleRate
    }
    
    func advanceTimeAndReturnValue() -> Float {
        return tones
            .map { $0.advanceTimeAndReturnValue() }
            .reduce(0, +)
    }
    
    func release() {
        tones.forEach { $0.release() }
    }
    
    func start(time: Float) {
        tones.forEach { $0.start(time: time) }
    }
    
}
