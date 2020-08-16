//
//  Track.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

protocol Track {
    var length: Float { get }
    func advanceTimeAndReturnNextValue() -> Float
}
