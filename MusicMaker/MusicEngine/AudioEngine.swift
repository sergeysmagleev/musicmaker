//
//  AudioEngine.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import AVFoundation

protocol AudioEngineDelegate: AnyObject {
    func audioEngineValueForNextFrame() -> Float
}

class AudioEngine {
    
    private let audioEngine = AVAudioEngine()
    private var timeStamp: Float = 0
    
    var sampleRate: Float {
        return Float(audioEngine.outputNode.inputFormat(forBus: 0).sampleRate)
    }
    
    weak var delegate: AudioEngineDelegate?
    
    init() {
        prepareEngine()
    }
    
    private func prepareEngine() {
        let mainMixer = audioEngine.mainMixerNode
        let output = audioEngine.outputNode
        let outputFormat = output.inputFormat(forBus: 0)
        let inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: outputFormat.sampleRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)
        let sourceNode = AVAudioSourceNode { [unowned self] _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0 ..< Int(frameCount) {
                let value = (self.delegate?.audioEngineValueForNextFrame() ?? 0) / 5.0
                let capped = min(1.0, max(-1.0, value))
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = Float(capped)
                }
            }
            return noErr
        }
        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: output, format: outputFormat)
        mainMixer.outputVolume = 1.0
    }
    
    func play() {
        do {
            try audioEngine.start()
        } catch (let error) {
            print(error)
        }
    }
    
    func pause() {
        audioEngine.stop()
    }
    
    func stop() {
        timeStamp = 0
        audioEngine.stop()
    }
    
}
