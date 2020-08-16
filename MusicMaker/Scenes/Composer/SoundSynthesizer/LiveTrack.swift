//
//  LiveTrack.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class LiveTrackSwift: Track {
    
    private var tones = [LFOTone]()
    private var currentTimeStamp: Float = 0
    private var currentLFOTimeStamp: Float = 0
    private var lfoFrequency: Float = 2
    
    private let sampleRate: Float
    private var timeIncrement: Float {
        1 / sampleRate
    }
    
    init(sampleRate: Float) {
        self.sampleRate = sampleRate
    }

    var length: Float {
        return Float(Int.max)
    }
    
    func advanceTimeAndReturnNextValue() -> Float {
        currentLFOTimeStamp += timeIncrement * lfoFrequency
        currentTimeStamp += timeIncrement * (sin(currentLFOTimeStamp))
        return tones
            .map { $0.advanceTimeAndReturnValue() }
            .reduce(0, +)
    }
    
    func addTone(tone: LFOTone) {
        tones.append(tone)
    }
    
    func startPlayingNote(at index: Int) {
        tones[index].start(time: currentTimeStamp)
    }
    
    func stopPlayingNote(at index: Int) {
        tones[index].release()
    }
}
