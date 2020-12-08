//
//  StringTrackView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 31.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

protocol StringTrackViewDelegate: AnyObject {
    func stringTrackView(_ sender: StringTrackView,
                         didAddBeatAtNote note: Int,
                         timeStamp: Int,
                         beatID: String)
    func stringTrackView(_ sender: StringTrackView,
                         didRemoveBeatAtNote note: Int,
                         beatID: String)
}

class StringTrackView: UIView {
    
    private var numOfBeats: Int!
    private var numOfInstruments: Int!
    private var newBoxCoordinates: CGPoint?
    private var pressed = false
    private var beatIDs = [UIView : String]()
    
    private let backgroundView = StringTrackBackgroundView()
    
    weak var delegate: StringTrackViewDelegate?
    
    private let square: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.frame = CGRect(x: 0, y: 0, width: 44.0, height: 32.0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
    }
    
    private func setup() {
        addSubview(backgroundView)
        backgroundColor = ColorPalette.mainBackground
//        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
//        longTap.delegate = self
//        addGestureRecognizer(longTap)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
//        pan.delegate = self
//        addGestureRecognizer(pan)
    }
    
    func configure(withNumberOfBeats numberOfBeats: Int,
                   numberOfInstruments: Int,
                   noteNames: [String]) {
        self.numOfBeats = numberOfBeats
        self.numOfInstruments = numberOfInstruments
        backgroundView.configure(trackHeight: 32.0,
                                 columnWidth: 44.0,
                                 numberOfBeats: numOfBeats,
                                 numberOfInstruments: numOfInstruments,
                                 noteNames: noteNames)
        frame = CGRect(x: 0,
                       y: 0,
                       width: 44.0 * CGFloat(numberOfBeats),
                       height: 32.0 * CGFloat(numberOfInstruments))
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        switch sender.state {
        case .began:
            pressed = true
            addSubview(square)
            square.center = location
            performAppearAnimation(on: square)
        case .changed:
            break
        case .ended:
            addNewNote(at: location)
            square.removeFromSuperview()
            pressed = false
        default:
            square.removeFromSuperview()
            pressed = false
        }
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        addNewNote(at: location)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if pressed {
                print("moving while pressed")
            } else {
                print("now moving even though it's not pressed tbh")
            }
            break
        case .changed:
            let location = sender.location(in: self)
            square.center = location
        case .ended:
            break
        case .cancelled, .failed:
            break
        default:
            break
        }
    }
    
    @objc private func didTapNote(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let noteId = beatIDs[view] else {
            return
        }
        let note = Int(view.center.y / 32.0)
        delegate?.stringTrackView(self, didRemoveBeatAtNote: note, beatID: noteId)
        view.removeFromSuperview()
    }
    
    private func addNewNote(at point: CGPoint) {
        let note = Int(point.y / 32.0)
        let beat = Int((point.x - 60) / 44.0)
        let newCoords = CGPoint(x: CGFloat(trunc((point.x - 60) / 44.0) * 44.0 + 60),
                                y: CGFloat(trunc(point.y / 32.0) * 32.0))
        let newSquareFrame = CGRect(origin: newCoords, size: CGSize(width: 44.0, height: 32.0))
        let newSquare = UIView(frame: newSquareFrame)
        addSubview(newSquare)
        newSquare.backgroundColor = .green
        newSquare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNote(_:))))
        let uuid = UUID().uuidString
        delegate?.stringTrackView(self, didAddBeatAtNote: note, timeStamp: beat, beatID: uuid)
        beatIDs[newSquare] = uuid
    }
    
    private func performAppearAnimation(on view: UIView) {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.duration = 0.5
        keyFrameAnimation.keyTimes = [0.0, 0.1, 0.2]
        keyFrameAnimation.values = [0.0, 1.2, 1.0]
        view.layer.add(keyFrameAnimation, forKey: "transform")
    }
    
    private func performPopAnimation(on view: UIView) {
        
    }
    
    private func performDisappearAnimation(on view: UIView, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform")
        keyFrameAnimation.keyTimes = [0.0, 0.1, 0.2].map { NSNumber(value: $0) }
        keyFrameAnimation.values = [CATransform3DIdentity,
                                    CATransform3DMakeScale(1.2, 1.2, 1.2),
                                    CATransform3DMakeScale(0.0, 0.0, 1.0)]
        view.layer.add(keyFrameAnimation, forKey: "transform")
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
    
}

extension StringTrackView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UILongPressGestureRecognizer else {
            return false
        }
        if type(of: otherGestureRecognizer) == UIPanGestureRecognizer.self {
            return true
        }
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIPanGestureRecognizer else {
            return true
        }
        return pressed
    }
    
}
