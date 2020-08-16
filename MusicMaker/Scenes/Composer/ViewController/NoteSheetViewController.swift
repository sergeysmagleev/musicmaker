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
    
    private let audioEngine = AudioEngine()
//    private lazy var track = ToneTrack(sampleRate: audioEngine.sampleRate)
    private var track: ComposedTrack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        track = ComposedTrack()
        audioEngine.delegate = self
//        drumTrackView.configure(numOfBeats: 64, numOfInstruments: 3)
//        drumTrackView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        return
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
    
}

extension NoteSheetViewController: AudioEngineDelegate {
    
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
        track.toggleBeat(forInstrument: instrument, beat: index, drumId: drumID)
    }
    
}
