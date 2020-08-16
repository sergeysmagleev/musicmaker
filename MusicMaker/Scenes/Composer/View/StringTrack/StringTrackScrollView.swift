//
//  StringTrackScrollView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 10.08.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class StringTrackScrollView: UIView {
    
    var scrollView = UIScrollView()
    var stringTrackView = StringTrackView()
    
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
        scrollView.frame = bounds
        scrollView.contentSize = stringTrackView.frame.size
    }

    private func setup() {
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.addSubview(stringTrackView)
        stringTrackView.configure(withNumberOfBeats: 64, numberOfInstruments: 10)
    }
    
}
