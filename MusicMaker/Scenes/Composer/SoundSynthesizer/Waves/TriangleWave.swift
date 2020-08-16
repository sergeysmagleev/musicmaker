//
//  TriangleWave.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class SawtoothWave: Wave {
    
    override func shape(_ value: Float) -> Float {
        return value.truncatingRemainder(dividingBy: Float.pi * 2) / (Float.pi * 2)
    }
    
}
