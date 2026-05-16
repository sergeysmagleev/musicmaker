//
//  ToneVisualizerViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 12.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class ToneVisualizerViewController: UIViewController {
    
    @IBOutlet weak var toneVisualizerView: ToneVisualizerView!
    @IBOutlet weak var frequencyVisualizerView: FrequencyVisualizerView!
    
    private let recordedTrack = RecordedTrack()
    private let audioEngine = AudioEngine()
    private var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordedTrack.delegate = self
//        let points = recordedTrack.get_points()
//        let points_count = recordedTrack.get_points_count()
//        let points = recordedTrack.get_frequency_analysis()
//        let array = Array(UnsafeBufferPointer(start: points, count: Int(points_count)))
//        let swapped = array.map { $0.bigEndian }
//        toneVisualizerView.points = array.map { CGFloat($0) }
//        points.deallocate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkNextFrame))
        displayLink.add(to: RunLoop.main, forMode: .default)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        playing = !playing
        if playing {
            recordedTrack.start()
            audioEngine.play()
        } else {
            recordedTrack.stop()
            audioEngine.stop()
        }
    }
    
    @objc func displayLinkNextFrame(_ sender: CADisplayLink) {
        sender.duration
//        self.toneVisualizerView.updateOneFrame()
        recordedTrack.prepareWaveFragment()
        let wave = Array(UnsafeBufferPointer(start: recordedTrack.wave_fragment(),
                                             count: Int(recordedTrack.wave_buffer_size())))
        let freq = Array(UnsafeBufferPointer(start: recordedTrack.frequency_fragment(),
                                             count: Int(recordedTrack.wave_buffer_size())))
        toneVisualizerView.points = wave.map(CGFloat.init)
        frequencyVisualizerView.points = freq.map(CGFloat.init)
//            recordedTrack.wave_fragment()
    }
}

extension ToneVisualizerViewController {
    func audioEngineValueForNextFrame() -> Float {
//        updateVisualizer()
        let value = recordedTrack.next_sample()
//        print(value)
        return value
    }
    
    func updateVisualizer() {
        DispatchQueue.main.async {
            self.toneVisualizerView.updateOneFrame()
        }
    }
}

extension ToneVisualizerViewController: RecordedTrackDelegate {
    
    func recordedTrackDidGetNewBuffer(_ data: UnsafeMutablePointer<Int16>, length: UInt) {
        var retVal = [CGFloat]()
        retVal.reserveCapacity(Int(length) / 2)
        for i in 0 ..< Int(length) / 4 {
            retVal.append(CGFloat(data[i * 2]) / CGFloat(Int16.max))
        }
//        toneVisualizerView.points = retVal
    }
    
}
