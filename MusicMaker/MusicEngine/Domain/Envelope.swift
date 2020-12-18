//
//  Envelope.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

protocol Envelope {
//    var finishedPlayingHandler: (() -> Void)? { get set }
    func release()
//    func amplifier(at time: Float) -> Float
    func advanceTimeAndReturnValue() -> Float
    func reset()
}
