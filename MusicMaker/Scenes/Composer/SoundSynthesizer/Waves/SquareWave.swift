//
//  SquareWave.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class SquareWave: Wave {
    
    override func shape(_ value: Float) -> Float {
        return Int(value / Float.pi) % 2 == 0 ? 1 : -1
    }
    
}
