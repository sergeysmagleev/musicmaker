//
//  LinearEnvelope.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

class LinearEnvelope: Envelope {
    
    var finishedPlayingHandler: (() -> Void)?
    var startingTime: Float = 0
    private let attackDuration: Float
    private let decayDuration: Float
    private let releaseDuration: Float
    private let sustainAmplitude: Float
    private var releaseTime: Float?
    private var latestPlayTime: Float = 0
    private var time: Float = 0
    private var keyFramePoints: [(Float, Float)] = []
    private var keyFrameIndex = 0
    private let sampleRate: Float
    private var played = false
    private var multiplier: Float = 0
    private var increments: [Float] = []
    private var value: Float = 0.0
    
    private var timeIncrement: Float {
        return 1 / sampleRate
    }
    
    init(attackDuration: Float,
         decayDuration: Float,
         releaseDuration: Float,
         sustainAmplitude: Float,
         releaseTime: Float? = nil,
         sampleRate: Float) {
        keyFramePoints = [(0.0, 0.0),
                          (attackDuration, 1.0),
                          (attackDuration + decayDuration, sustainAmplitude)]
        if let releaseTime = releaseTime {
            let zero: Float = 0.0
            keyFramePoints += [(releaseTime, sustainAmplitude),
                               (releaseTime + releaseDuration, zero)]
        }
        self.attackDuration = attackDuration
        self.decayDuration = decayDuration
        self.releaseDuration = releaseDuration
        self.sustainAmplitude = sustainAmplitude
        self.releaseTime = releaseTime
        self.sampleRate = sampleRate
        for i in 1 ..< keyFramePoints.count {
            increments.append((keyFramePoints[i].1 - keyFramePoints[i - 1].1)
                / (keyFramePoints[i].0 - keyFramePoints[i - 1].0) * timeIncrement)
        }
        print(keyFramePoints)
        print(increments)
    }
    
    func release() {
//        releaseTime = max(latestPlayTime, attackDuration + decayDuration)
        let zero: Float = 0.0
        keyFramePoints += [(time, sustainAmplitude),
                           (time + releaseDuration, zero)]
    }
    
    func advanceTimeAndReturnValue() -> Float {
        guard played else {
            return keyFramePoints.last!.1
        }
        guard time >= 0.0 else {
            return 0.0
        }
        time += timeIncrement
        while keyFrameIndex < increments.count && time > keyFramePoints[keyFrameIndex + 1].0 {
            keyFrameIndex += 1
        }
        guard keyFrameIndex < increments.count else {
            played = false
            return 0.0
        }
        value += increments[keyFrameIndex]
        return value
    }
    
//    func amplifier(at time: Float) -> Float {
//        if time < startingTime {
//            return 0
//        }
//        let adjustedTime = time - startingTime
//        latestPlayTime = adjustedTime
//        if adjustedTime < attackDuration {
//            return adjustedTime * (1 / attackDuration)
//        } else if adjustedTime < attackDuration + decayDuration {
//            return 1 - (adjustedTime - attackDuration) * (1 / decayDuration) * (1 - sustainAmplitude)
//        } else if let releaseTime = releaseTime {
//            if releaseTime + releaseDuration < adjustedTime {
//                finishedPlayingHandler?()
//                return 0
//            }
//            if adjustedTime < releaseTime {
//                return sustainAmplitude
//            } else {
//                let releaseTimeStamp = adjustedTime - releaseTime
//                return max(0, sustainAmplitude - releaseTimeStamp * (sustainAmplitude / releaseDuration))
//            }
//        } else {
//            print(adjustedTime)
//            return sustainAmplitude
//        }
//    }
    
    func reset() {
//        releaseTime = nil
//        value = 0
        keyFramePoints[0].1 = value
        increments[0] = ((keyFramePoints[1].1 - keyFramePoints[0].1)
            / (keyFramePoints[1].0 - keyFramePoints[0].0) * timeIncrement)
        
        keyFrameIndex = 0
        played = true
        time = 0
        startingTime = 0
        latestPlayTime = 0
    }
    
}
