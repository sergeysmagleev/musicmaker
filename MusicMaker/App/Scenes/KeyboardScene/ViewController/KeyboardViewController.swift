//
//  KeyboardViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 26.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit
import AVKit

class KeyboardViewController: UIViewController {
    
    private static let twoPi = Float.pi * 2
    private static let frequencies = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00,
                                      493.88, 523.25, 587.33, 659.25, 698.46, 783.99,
                                      880.00, 987.77, 1046.50]
    private static let allFrequencies: [Float] = [261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00,
                                                  466.16, 493.88, 523.25, 554.37, 587.33, 622.25, 659.25, 698.46, 739.99, 783.99,
                                                  830.61, 880.00, 932.33, 987.77, 1046.50, 1108.73]
    private let notes: [Note] = [.C4, .Cd4, .D4, .Dd4, .E4, .F4, .Fd4, .G4, .Gd4, .A4, .Ad4, .B4, .C5, .Cd5, .D5, .Dd5, .E5, .F5, .Fd5, .G5, .Gd5, .A5, .Ad5, .B5]
//    private let notes: [Note] = [.C2, .Cd2, .D2, .Dd2, .E2, .F2, .Fd2, .G2, .Gd2, .A2, .Ad2, .B2]
//    private let notes: [Note] = [.C3, .Cd3, .D3, .Dd3, .E3, .F3, .Fd3, .G3, .Gd3, .A3, .Ad3, .B3]
//    private let notes: [Note] = [.C1, .Cd1, .D1, .Dd1, .E1, .F1, .Fd1, .G1, .Gd1, .A1, .Ad1, .B1]
//    private let notes: [Note] = [.C3]
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    private var envelope: Envelope!
    private var compositeWave = CompositeWave(waves: [])
    private var playTimeStamp: Float = 0
    
    private let audioEngine = AudioEngine()
    private lazy var track = LiveTrack(sampleRate: Float(audioEngine.sampleRate))
//    private lazy let track = CLiveTrack(audioEngine.sampleRate)

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardView.delegate = self
        track.addSignals()
//        for (index, note) in notes.enumerated() {
//            track.addTone(withFrequency: Note.F3.frequency, lfoFrequency: powf(2.0, Float(index)), isKick: index < 5)
//            track.addTone(tone: LFOTone(tone:
////                Noise(),
//                CompositeWave(waves: [
//                    SawtoothWave(frequency: note.frequency,
//                                 amplitude: 0.5,
//                    phaseShift: 0.0),
//                    SineWave(frequency: note.frequency,
//                             amplitude: 0.5,
//                         phaseShift: 0.0),
//            ]),
//                                           ampEnvelope: LinearEnvelope(attackDuration: 0.2,
//                                                                       decayDuration: 0.01,
//                                                                       releaseDuration: 0.1,
//                                                                       sustainAmplitude: 1.0,
//                                                                       releaseTime: 2.0,
//                                                                       sampleRate: audioEngine.sampleRate),
//                                           lfoFrequency: 2.0,
//                                           sampleRate: audioEngine.sampleRate))
//        }
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        audioEngine.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioEngine.stop()
    }
    
    private func startPlayingSound() {
        audioEngine.stop()
        audioEngine.play()
    }
    
    private func stopPlayingSound() {
//        self.currentPhase = 0
        envelope.release()
    }
    
}

extension KeyboardViewController {
    func audioEngineValueForNextFrame() -> Float {
        return track.advanceTimeAndReturnNextValue()
    }
}

extension KeyboardViewController: KeyboardViewDelegate {
    
    func keyboardView(_ sender: KeyboardView, didPressKeys keys: Set<Int>) {
//        print("start playing")
        for key in keys {
            track.startPlayingNote(at: Int32(key))
        }
    }
    
    func keyboardView(_ sender: KeyboardView, didReleaseKeys keys: Set<Int>) {
//        print("finish playing")
        for key in keys {
            track.stopPlayingNote(at: Int32(key))
        }
    }
    
    func keyboardView(_ sender: KeyboardView, didChangePressedKeys keys: Set<Int>) {
        if keys.count > 0 {
            let value = keys.randomElement()!
            compositeWave = CompositeWave(waves: [SineWave(frequency: Self.allFrequencies[value],
                                                             amplitude: 1,
                                                           phaseShift: 0)])
            
//            compositeWave = CompositeWave(waves: [SineWave(frequency: Self.allFrequencies[value],
//                                                           amplitude: 0.6366,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: Self.allFrequencies[value] * 3,
//                                                           amplitude: -0.2122,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: Self.allFrequencies[value] * 5,
//                                                           amplitude: 0.1273,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: Self.allFrequencies[value] * 7,
//                                                           amplitude: -0.0909,
//                                                           phaseShift: 0)])
            
//            compositeWave = CompositeWave(waves: [SineWave(frequency: baseFrequency,
//                                                           amplitude: 0.8106,
//                                                           phaseShift: 0)])
            
//            compositeWave = CompositeWave(waves: [SineWave(frequency: baseFrequency,
//                                                           amplitude: 0.8106,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: baseFrequency * 3,
//                                                           amplitude: 0.0901,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: baseFrequency * 5,
//                                                           amplitude: 0.0324,
//                                                           phaseShift: 0),
//                                                  SineWave(frequency: baseFrequency * 7,
//                                                           amplitude: 0.0165,
//                                                           phaseShift: 0)])
            startPlayingSound()
        } else {
            stopPlayingSound()
        }
    }
}
