//
//  ToneVisualizerView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 12.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class ToneVisualizerView: UIView {
    
    private var pointer: Int = 0
    private var offset: Int = 0
    
    var points: [CGFloat] = [] {
        didSet {
            pointer = 0
            offset = 0
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.black.cgColor)
        context.fill(bounds)
        let gap = frame.size.width / CGFloat(points.count)
        let amp: CGFloat = 200
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: 0, y: frame.height / 2))
        context.addLine(to: CGPoint(x: frame.width, y: frame.height / 2))
        context.strokePath()
        context.setLineWidth(1)
        context.move(to: CGPoint(x: 0, y: frame.height / 2))
        context.setStrokeColor(UIColor.green.cgColor)
        for i in 0 ..< max(0, min(points.count - offset, Int(rect.size.width))) {
            context.addLine(to: CGPoint(x: CGFloat(i) * gap, y: frame.height / 2 - points[i + offset] * amp))
        }
        context.strokePath()
    }
    
    func updateOneFrame() {
//        pointer += 1
//        if pointer >= 30 {
        offset += max(points.count, points.count - Int(bounds.size.width)) / 60
            pointer = 0
            self.setNeedsDisplay()
//        }
    }
    

}
