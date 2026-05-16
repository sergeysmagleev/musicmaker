//
//  DrumTrackViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 14.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class DrumTrackViewController: UIViewController {
    private enum Layout {
        static let controlSpacing: CGFloat = 16.0
    }
    
    @IBOutlet weak var drumTrackView: DrumTrackView!
    @IBOutlet weak var playButton: UIButton!
    
    private let audioEngine = AudioEngine()
    private let mixer = AudioMixer()
    private lazy var track = DrumMachineTrack(sampleRate: audioEngine.sampleRate)
    private var playing = false
    private var bpm = 96 {
        didSet {
            bpmValueLabel.text = "\(bpm)"
        }
    }
    
    private let bpmTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = ColorPalette.secondary
        label.text = "BPM"
        return label
    }()
    
    private let bpmValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 20.0, weight: .bold)
        label.textColor = ColorPalette.selected
        label.textAlignment = .center
        return label
    }()
    
    private let bpmStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 60
        stepper.maximumValue = 180
        stepper.stepValue = 2
        stepper.value = 96
        return stepper
    }()
    
    private lazy var bpmStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bpmTitleLabel, bpmValueLabel, bpmStepper])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Layout.controlSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mixer.addRenderSource(track)
        audioEngine.renderSource = mixer
        track.setBPM(bpm)
        drumTrackView.configure(numOfBeats: 64, numOfInstruments: 3)
        drumTrackView.delegate = self
        drumTrackView.loadDefaultPattern()
        drumTrackView.layer.cornerRadius = 16.0
        drumTrackView.layer.masksToBounds = true
        setupLayout()
        bpmStepper.addTarget(self, action: #selector(bpmChanged(_:)), for: .valueChanged)
        view.backgroundColor = ColorPalette.secondary
    }
    
    private func setupLayout() {
        let managedViews = [drumTrackView, playButton]
        let constraintsToRemove = view.constraints.filter { constraint in
            guard let firstItem = constraint.firstItem as? UIView else {
                return false
            }
            let secondItem = constraint.secondItem as? UIView
            return managedViews.contains(firstItem) || (secondItem.map { managedViews.contains($0) } ?? false)
        }
        NSLayoutConstraint.deactivate(constraintsToRemove)
        view.addSubview(bpmStackView)
        drumTrackView.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        bpmValueLabel.text = "\(bpm)"
        NSLayoutConstraint.activate([
            bpmStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            bpmStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            drumTrackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            drumTrackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            drumTrackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            drumTrackView.heightAnchor.constraint(equalToConstant: 240.0),
            
            playButton.topAnchor.constraint(equalTo: drumTrackView.bottomAnchor, constant: 24.0),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
    
    @objc private func bpmChanged(_ sender: UIStepper) {
        bpm = Int(sender.value)
        track.setBPM(bpm)
    }
    
}

extension DrumTrackViewController: DrumTrackViewDelegate {
    
    func drumTrackView(_ sender: DrumTrackView,
                       didTapInstrument instrument: Int,
                       atIndex index: Int,
                       drumID: String) {
        track.toggleStep(forInstrument: instrument, beat: index)
    }
    
}
