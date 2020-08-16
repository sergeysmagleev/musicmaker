//
//  DrumBeatView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 19.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class DrumBeatView: UIView {
    
    private static let cornerRadius: CGFloat = 6.0
    
    private var edgeInset: CGFloat!
    private var inactiveColor: UIColor!
    private var selectedColor: UIColor!
    private var playedColor: UIColor!
    private(set) var isActive = false
    private var isPlayed = false
    
    private let innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = ColorPalette.secondary.cgColor
        view.layer.borderWidth = 3.0
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
    
    private func setup() {
        addSubview(innerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerView.frame = self.bounds.insetBy(dx: edgeInset, dy: edgeInset)
    }
    
    func configure(edgeInset: CGFloat,
                   inactiveColor: UIColor,
                   selectedColor: UIColor,
                   playedColor: UIColor) {
        self.edgeInset = edgeInset
        self.inactiveColor = inactiveColor
        self.selectedColor = selectedColor
        self.playedColor = playedColor
        innerView.backgroundColor = inactiveColor
    }
    
    func setActive(_ active: Bool) {
        isActive = active
        if isActive {
            innerView.backgroundColor = selectedColor
        } else {
            innerView.backgroundColor = inactiveColor
        }
    }
    
    func setPlaying(_ playing: Bool) {
        isPlayed = playing
        if isPlayed {
            
        } else {
            
        }
    }
    
    private func makeInactive() {
        
    }
    
    private func makeSelected() {
        
    }
    
    private func makePlayed() {
        
    }
    
}
