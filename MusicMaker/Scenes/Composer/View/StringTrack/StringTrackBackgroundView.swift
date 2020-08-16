//
//  StringTrackBackgroundView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.08.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class StringTrackBackgroundView: UIView {
    
    private var trackHeight: CGFloat!
    private var columnWidth: CGFloat!
    
    private var numberOfInstruments: Int!
    private var numberOfBeats: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(trackHeight: CGFloat,
                   columnWidth: CGFloat,
                   numberOfBeats: Int,
                   numberOfInstruments: Int) {
        self.trackHeight = trackHeight
        self.columnWidth = columnWidth
        self.numberOfBeats = numberOfBeats
        self.numberOfInstruments = numberOfInstruments
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setStrokeColor(UIColor.white.cgColor)
        for i in 0 ... numberOfInstruments {
            context.move(to: CGPoint(x: 0, y: CGFloat(i) * trackHeight))
            context.addLine(to: CGPoint(x: frame.size.width, y: CGFloat(i) * trackHeight))
            context.strokePath()
        }
        let offset: CGFloat = 60.0
        context.setStrokeColor(UIColor.lightGray.cgColor)
        for i in 0 ... numberOfBeats {
            context.move(to: CGPoint(x: CGFloat(i) * columnWidth + offset, y: 0))
            context.addLine(to: CGPoint(x: CGFloat(i) * columnWidth + offset, y: frame.size.height))
            context.strokePath()
        }
    }
    
}
