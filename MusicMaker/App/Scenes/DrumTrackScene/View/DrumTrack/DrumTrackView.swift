//
//  DrumTrackView.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 18.07.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

protocol DrumTrackViewDelegate: AnyObject {
    func drumTrackView(_ sender: DrumTrackView,
                       didTapInstrument instrument: Int,
                       atIndex index: Int,
                       drumID: String)
}

class DrumTrackView: UIView {
    
    private let drumBeatCellWidth: CGFloat = 24.0
    private let drumBeatCellHeight: CGFloat = 36.0
    private let drumBeatCellVerticalGap: CGFloat = 10.0
    private let drumBeatCellHorizontalGap: CGFloat = 10.0
    
    private var numOfBeats: Int!
    private var numOfInstruments: Int!
//    private
    
    private let scrollView = UIScrollView()
    private let drumTrackBackgroundView = DrumTrackBackgroundView()
    private var drumBeatViews: [[DrumBeatView]] = []
    private var drumIDs: [[String]] = []
    
    weak var delegate: DrumTrackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = ColorPalette.mainBackground
        drumTrackBackgroundView.configure(mainColor: ColorPalette.mainBackground,
                                          offColor: ColorPalette.shadeBackground,
                                          columnWidth: drumBeatCellWidth * 4.0)
        addSubview(scrollView)
        scrollView.addSubview(drumTrackBackgroundView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        for i in 0 ..< numOfInstruments {
            for j in 0 ..< numOfBeats {
                drumBeatViews[i][j].frame = CGRect(x: CGFloat(j) * drumBeatCellWidth,
                                                   y: CGFloat(i) * drumBeatCellHeight,
                                                   width: drumBeatCellWidth,
                                                   height: drumBeatCellHeight)
            }
        }
    }
    
    func configure(numOfBeats: Int, numOfInstruments: Int) {
        self.numOfBeats = numOfBeats
        self.numOfInstruments = numOfInstruments
        scrollView.contentSize = CGSize(width: drumBeatCellWidth * CGFloat(numOfBeats),
                                        height: drumBeatCellHeight * CGFloat(numOfInstruments))
        drumTrackBackgroundView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        for row in drumBeatViews {
            for view in row {
                view.removeFromSuperview()
            }
        }
        drumBeatViews = []
        drumIDs = []
        for i in 0 ..< numOfInstruments {
            drumBeatViews.append([])
            drumIDs.append([])
            for j in 0 ..< numOfBeats {
                let view = DrumBeatView(frame: CGRect(x: CGFloat(j) * drumBeatCellWidth,
                                                      y: CGFloat(i) * drumBeatCellHeight,
                                                      width: drumBeatCellWidth,
                                                      height: drumBeatCellHeight))
                view.configure(edgeInset: 2.0,
                               inactiveColor: ColorPalette.mainBackground,
                               selectedColor: ColorPalette.selected,
                               playedColor: ColorPalette.played)
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDrumBeat(_:))))
                drumBeatViews[i].append(view)
                drumIDs[i].append(UUID().uuidString)
                scrollView.addSubview(view)
            }
        }
    }
    
    @objc private func didTapDrumBeat(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? DrumBeatView else {
            return
        }
        var instrument = -1
        var beat = -1
        for i in 0 ..< numOfInstruments {
            if let index = drumBeatViews[i].firstIndex(of: view) {
                beat = index
                instrument = i
                break
            }
        }
        guard instrument > -1, beat > -1 else {
            return
        }
        delegate?.drumTrackView(self,
                                didTapInstrument: instrument,
                                atIndex: beat,
                                drumID: drumIDs[instrument][beat])
        view.setActive(view.isActive ? false : true)
    }
    
}
