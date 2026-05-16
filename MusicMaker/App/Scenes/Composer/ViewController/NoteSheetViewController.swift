//
//  NoteSheetViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class NoteSheetViewController: UIViewController {
//    @IBOutlet weak var drumTrackView: DrumTrackView!
    @IBOutlet weak var playButton: UIButton!
    private var playing = false
    @IBOutlet weak var stringTrackView: StringTrackScrollView!
    @IBOutlet weak var noteLengthStepper: UIStepper!
    @IBOutlet weak var noteLengthLabel: UILabel!
    @IBOutlet weak var toneVisualizerView: ToneVisualizerView!
    @IBOutlet weak var frequencyVisualizerView: FrequencyVisualizerView!
    
    private let audioEngine = AudioEngine()
//    private lazy var track = ToneTrack(sampleRate: audioEngine.sampleRate)
    private var track: ComposedTrack!
    
    private var currentBeatLength: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        track = ComposedTrack()
        track.delegate = self
        stringTrackView.setTrackViewDelegate(self)
        stringTrackView.configure(withNumberOfBeats: 64,
                                  numberOfInstruments: 24,
                                  noteNames: [
                                    "C5",
                                    "Cd5",
                                    "D5",
                                    "Dd5",
                                    "E5",
                                    "F5",
                                    "Fd5",
                                    "G5",
                                    "Gd5",
                                    "A5",
                                    "Ad5",
                                    "B5",
                                    "C6",
                                    "Cd6",
                                    "D6",
                                    "Dd6",
                                    "E6",
                                    "F6",
                                    "Fd6",
                                    "G6",
                                    "Gd6",
                                    "A6",
                                    "Ad6",
                                    "B6"
        ])
//        drumTrackView.configure(numOfBeats: 64, numOfInstruments: 3)
//        drumTrackView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let displaylink = CADisplayLink(target: self, selector: #selector(didRefreshScreen(_:)))
        displaylink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        playing = !playing
        if playing {
//            track.prepareToPlay()
            playButton.setTitle("Stop", for: .normal)
            track.start()
            audioEngine.play()
        } else {
            playButton.setTitle("Play", for: .normal)
            track.stop()
            audioEngine.stop()
        }
    }
    
    @IBAction func noteStepperTapped(_ sender: Any) {
        guard let stepper = sender as? UIStepper else {
            return
        }
        currentBeatLength = Int(stepper.value)
        noteLengthLabel.text = String(format: "%d", Int(stepper.value))
    }
    
    @objc func didRefreshScreen(_ sender: CADisplayLink) {
        DispatchQueue.main.async {
            let points = [Float](UnsafeBufferPointer(start: self.track.replayValues(), count: 512))
                .map(CGFloat.init)
            self.toneVisualizerView.points = points
        }
    }
    
}

extension NoteSheetViewController {
    
    func audioEngineValueForNextFrame() -> Float {
        if playing {
            return track.next_sample()
        }
        return 0
    }
    
}

extension NoteSheetViewController: DrumTrackViewDelegate {
    
    func drumTrackView(_ sender: DrumTrackView,
                       didTapInstrument instrument: Int,
                       atIndex index: Int,
                       drumID: String) {
        track.toggleBeat(forInstrument: instrument, beat: index, length: 1, drumId: drumID)
    }
    
}

extension NoteSheetViewController: StringTrackViewDelegate {
    
    func stringTrackView(_ sender: StringTrackView,
                         didAddBeatAtNote note: Int,
                         timeStamp: Int,
                         beatID: String) {
        track.addBeat(forInstrument: note, beat: timeStamp, length: currentBeatLength, drumId: beatID)
    }
    
    func stringTrackView(_ sender: StringTrackView,
                         didRemoveBeatAtNote note: Int,
                         beatID: String) {
        track.removeBeat(forInstrument: note, drumId: beatID)
    }
    
}

extension NoteSheetViewController: ComposedTrackDelegate {
    
    func composedTrack(_ track: ComposedTrack, didPrepareBuffer buffer: UnsafePointer<Float>) {
        //
    }
    
}
