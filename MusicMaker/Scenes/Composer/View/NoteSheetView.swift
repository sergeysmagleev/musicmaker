//
//  NoteSheetView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import CoreGraphics
import UIKit

protocol NoteSheetViewDelegate: AnyObject {
    func noteSheet(_ sender: NoteSheetView, didTapNote note: Int, at time: Float)
}

class NoteSheetView: UIView {
    
    private var barWidth: CGFloat = 16.0
    private var barHeight: CGFloat = 16.0
    private var mainColor = UIColor.gray
    private var mainLineColor = UIColor.white
    private var secondaryLineColor = UIColor.lightGray
    
    private var selectedNotes = [CGPoint]()
    
    weak var delegate: NoteSheetViewDelegate?
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(mainColor.cgColor)
        context.fill(rect)
        context.setFillColor(UIColor.blue.cgColor)
        for note in selectedNotes {
            context.fill(CGRect(x: note.x * barWidth,
                                y: note.y * barHeight,
                                width: barWidth,
                                height: barHeight))
        }
        context.setStrokeColor(secondaryLineColor.cgColor)
        var x: CGFloat = 0
        while x < rect.width {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
            context.strokePath()
            x += barWidth
        }
        context.setStrokeColor(mainLineColor.cgColor)
        var y: CGFloat = 0
        while y < rect.height {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            context.strokePath()
            y += barHeight
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let point = CGPoint(x: trunc(location.x / barWidth), y: trunc(location.y / barHeight))
        if let index = selectedNotes.firstIndex(of: point) {
            selectedNotes.remove(at: index)
        } else {
            selectedNotes.append(point)
        }
        delegate?.noteSheet(self, didTapNote: Int(point.y), at: Float(point.x))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
}
