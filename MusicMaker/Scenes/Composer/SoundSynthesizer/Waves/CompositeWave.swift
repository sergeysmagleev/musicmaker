//
//  CompositeWave.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 27.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class CompositeWave: Tone {
    
    private let waves: [Wave]
    
    init(waves: [Wave]) {
        self.waves = waves
    }
    
    func value(at time: Float) -> Float {
        return waves
            .map { $0.play(time: time) }
            .reduce(0, +)
    }
    
    func play(time: Float) -> Float {
        return waves
            .map { $0.play(time: time) }
            .reduce(0, +)
    }
    
}
