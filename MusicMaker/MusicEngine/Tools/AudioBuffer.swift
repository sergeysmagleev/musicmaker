//
//  AudioBuffer.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 29.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class AudioBuffer {
    
    private var buffer1: [Float]
    private var buffer2: [Float]
    private var currentPointer = 0
    
    init(size: Int) {
        buffer1 = [Float](repeating: 0, count: size)
        buffer2 = [Float](repeating: 0, count: size)
    }
    
}
