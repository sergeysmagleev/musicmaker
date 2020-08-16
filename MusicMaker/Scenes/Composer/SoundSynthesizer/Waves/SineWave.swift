//
//  SineWave.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 27.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class SineWave: Wave {
    
    override func shape(_ value: Float) -> Float {
        sine_wave(value)
    }
    
}
