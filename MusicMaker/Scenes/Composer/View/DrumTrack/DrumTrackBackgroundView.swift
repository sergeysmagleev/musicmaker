//
//  DrumTrackBackgroundView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 21.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class DrumTrackBackgroundView: UIView {
    
    private var mainColor: UIColor!
    private var offColor: UIColor!
    private var columnWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(mainColor: UIColor, offColor: UIColor, columnWidth: CGFloat) {
        self.mainColor = mainColor
        self.offColor = offColor
        self.columnWidth = columnWidth
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
        for i in 0 ..< Int(ceil(frame.width / columnWidth)) {
            context.setFillColor(i % 2 == 0 ? mainColor.cgColor : offColor.cgColor)
            context.fill(CGRect(x: CGFloat(i) * columnWidth,
                                y: 0,
                                width: columnWidth,
                                height: frame.height))
        }
    }
    
}
