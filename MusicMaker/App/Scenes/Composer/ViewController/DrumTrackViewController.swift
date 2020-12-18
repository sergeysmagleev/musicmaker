//
//  DrumTrackViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class DrumTrackViewController: UIViewController {
    
    @IBOutlet weak var drumTrackView: DrumTrackView!
    @IBOutlet weak var playButton: UIButton!
    
    private let audioEngine = AudioEngine()
    private var track: ComposedTrack!
    private var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        track = ComposedTrack()
        audioEngine.delegate = self
        drumTrackView.configure(numOfBeats: 64, numOfInstruments: 3)
        drumTrackView.delegate = self
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        playing = !playing
        if playing {
            playButton.setTitle("Stop", for: .normal)
            track.start()
            audioEngine.play()
        } else {
            playButton.setTitle("Play", for: .normal)
            track.stop()
            audioEngine.stop()
        }
    }
    
}

extension DrumTrackViewController: AudioEngineDelegate {
    
    func audioEngineValueForNextFrame() -> Float {
        if playing {
            return track.next_sample()
        }
        return 0
    }
    
}

extension DrumTrackViewController: DrumTrackViewDelegate {
    
    func drumTrackView(_ sender: DrumTrackView,
                       didTapInstrument instrument: Int,
                       atIndex index: Int,
                       drumID: String) {
        track.toggleBeat(forInstrument: instrument, beat: index, length: 1, drumId: drumID)
    }
    
}
