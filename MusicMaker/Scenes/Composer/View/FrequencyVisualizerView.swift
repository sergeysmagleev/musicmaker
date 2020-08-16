//
//  FrequencyVisualizerView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 30.06.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class FrequencyVisualizerView: UIView {
    
     var points: [CGFloat] = [] {
           didSet {
               setNeedsDisplay()
           }
       }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.black.cgColor)
        context.fill(bounds)
        let amp: CGFloat = 10
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(3)
        context.setStrokeColor(UIColor.red.cgColor)
        for i in 0 ..< points.count {
            context.move(to: CGPoint(x: CGFloat(i * 4), y: frame.height))
            context.addLine(to: CGPoint(x: CGFloat(i * 4), y: frame.height - points[i] * amp))
            context.strokePath()
        }
    }
}
