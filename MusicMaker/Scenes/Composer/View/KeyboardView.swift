//
//  KeyboardView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 26.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func keyboardView(_ sender: KeyboardView, didPressKeys keys: Set<Int>)
    func keyboardView(_ sender: KeyboardView, didReleaseKeys keys: Set<Int>)
}

class KeyboardView: UIView {
    
    private let keyWidth: CGFloat = 64.0
    private var selectedKeys = Set<Int>()
    
    weak var delegate: KeyboardViewDelegate?
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        context.setFillColor(UIColor.yellow.cgColor)
        for key in selectedKeys {
            context.fill(CGRect(x: CGFloat(key) * keyWidth,
                                y: 0,
                                width: keyWidth,
                                height: frame.height))
        }
        context.setStrokeColor(UIColor.black.cgColor)
        var x: CGFloat = 0
        while x < rect.width {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
            context.strokePath()
            x += keyWidth
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let newSelectedKeys = touches
            .map { $0.location(in: self) }
            .map { Int($0.x / keyWidth) }
        updatePressedKeys(Set(newSelectedKeys))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let newSelectedKeys = touches
            .map { $0.location(in: self) }
            .map { Int($0.x / keyWidth) }
        updatePressedKeys(Set(newSelectedKeys))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        updatePressedKeys(Set<Int>())
    }
    
    private func updatePressedKeys(_ newKeys: Set<Int>) {
        if selectedKeys != newKeys {
            let pressed = newKeys.subtracting(selectedKeys)
            let released = selectedKeys.subtracting(newKeys)
            setNeedsDisplay()
            delegate?.keyboardView(self, didPressKeys: pressed)
            delegate?.keyboardView(self, didReleaseKeys: released)
            selectedKeys = newKeys
        }
    }
    
}
