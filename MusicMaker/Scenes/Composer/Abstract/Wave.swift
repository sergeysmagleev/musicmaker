//
//  Wave.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class Wave: Tone {
    private let frequency: Float
    private let amplitude: Float
    private let phaseShift: Float

    init(frequency: Float,
         amplitude: Float,
         phaseShift: Float) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.phaseShift = phaseShift
    }
    
    func shape(_ value: Float) -> Float {
        fatalError("this is an abstract class")
    }
    
    func play(time: Float) -> Float {
        let position = (Float.pi * 2 * frequency) * time
        return shape(phaseShift + position) * amplitude
    }
}
