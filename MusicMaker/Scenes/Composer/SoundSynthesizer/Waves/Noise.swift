//
//  Noise.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 03.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class Noise: Tone {
    
    func play(time: Float) -> Float {
        return Float(drand48() - drand48())
    }
    
}
