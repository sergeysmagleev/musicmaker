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
    private enum Layout {
        static let labelColumnWidth: CGFloat = 92.0
        static let cellWidth: CGFloat = 34.0
        static let cellHeight: CGFloat = 52.0
        static let rowGap: CGFloat = 16.0
        static let viewportSideInset: CGFloat = 24.0
        static let verticalPadding: CGFloat = 20.0
    }
    
    private var numOfBeats: Int!
    private var numOfInstruments: Int!
    private let instrumentNames = ["Kick", "Snare", "HiHat"]
    
    private let contentView = UIView()
    private let labelsContainerView = UIView()
    private let scrollView = UIScrollView()
    private let drumTrackBackgroundView = DrumTrackBackgroundView()
    private var drumBeatViews: [[DrumBeatView]] = []
    private var drumIDs: [[String]] = []
    private var instrumentLabels: [UILabel] = []
    
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
                                          columnWidth: Layout.cellWidth * 4.0)
        addSubview(contentView)
        contentView.addSubview(labelsContainerView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(drumTrackBackgroundView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delaysContentTouches = false
        labelsContainerView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let numOfBeats, let numOfInstruments else {
            return
        }
        let rowHeight = Layout.cellHeight + Layout.rowGap
        let gridHeight = CGFloat(numOfInstruments) * rowHeight - Layout.rowGap
        let availableWidth = max(bounds.width - Layout.viewportSideInset * 2.0, Layout.labelColumnWidth + Layout.cellWidth * 4.0)
        let availableHeight = max(bounds.height - Layout.verticalPadding * 2.0, gridHeight)
        contentView.frame = CGRect(x: (bounds.width - availableWidth) * 0.5,
                                   y: (bounds.height - availableHeight) * 0.5,
                                   width: availableWidth,
                                   height: availableHeight)
        labelsContainerView.frame = CGRect(x: 0,
                                           y: max(0, (contentView.bounds.height - gridHeight) * 0.5),
                                           width: Layout.labelColumnWidth,
                                           height: gridHeight)
        scrollView.frame = CGRect(x: Layout.labelColumnWidth,
                                  y: 0,
                                  width: contentView.bounds.width - Layout.labelColumnWidth,
                                  height: contentView.bounds.height)
        let contentWidth = Layout.cellWidth * CGFloat(numOfBeats)
        scrollView.contentSize = CGSize(width: contentWidth, height: gridHeight)
        let gridOriginY = max(0, (scrollView.bounds.height - gridHeight) * 0.5)
        drumTrackBackgroundView.frame = CGRect(x: 0, y: gridOriginY, width: contentWidth, height: gridHeight)
        for i in 0 ..< numOfInstruments {
            instrumentLabels[i].frame = CGRect(x: 0,
                                               y: CGFloat(i) * rowHeight,
                                               width: labelsContainerView.bounds.width - 12.0,
                                               height: Layout.cellHeight)
            for j in 0 ..< numOfBeats {
                drumBeatViews[i][j].frame = CGRect(x: CGFloat(j) * Layout.cellWidth,
                                                   y: gridOriginY + CGFloat(i) * rowHeight,
                                                   width: Layout.cellWidth,
                                                   height: Layout.cellHeight)
            }
        }
    }
    
    func configure(numOfBeats: Int, numOfInstruments: Int) {
        self.numOfBeats = numOfBeats
        self.numOfInstruments = numOfInstruments
        for row in drumBeatViews {
            for view in row {
                view.removeFromSuperview()
            }
        }
        for label in instrumentLabels {
            label.removeFromSuperview()
        }
        drumBeatViews = []
        drumIDs = []
        instrumentLabels = []
        for i in 0 ..< numOfInstruments {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            label.textColor = ColorPalette.secondary
            label.textAlignment = .right
            label.text = instrumentNames[i]
            labelsContainerView.addSubview(label)
            instrumentLabels.append(label)
            drumBeatViews.append([])
            drumIDs.append([])
            for j in 0 ..< numOfBeats {
                let view = DrumBeatView(frame: .zero)
                view.configure(edgeInset: 3.0,
                               inactiveColor: ColorPalette.mainBackground,
                               selectedColor: ColorPalette.selected,
                               playedColor: ColorPalette.played)
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDrumBeat(_:))))
                drumBeatViews[i].append(view)
                drumIDs[i].append(UUID().uuidString)
                scrollView.addSubview(view)
            }
        }
        setNeedsLayout()
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

extension DrumTrackView {
    
    func loadDefaultPattern() {
        for i in 0 ..< 4 {
            let view = drumBeatViews[0][i * 16]
            delegate?.drumTrackView(self,
                                    didTapInstrument: 0,
                                    atIndex: i * 16,
                                    drumID: drumIDs[0][i * 16])
            view.setActive(true)
        }
        for i in 0 ..< 4 {
            let view = drumBeatViews[0][i * 16 + 10]
            delegate?.drumTrackView(self,
                                    didTapInstrument: 0,
                                    atIndex: i * 16 + 10,
                                    drumID: drumIDs[0][i * 16 + 10])
            view.setActive(true)
        }
        for i in 0 ..< 8 {
            let view = drumBeatViews[1][i * 8 + 4]
            delegate?.drumTrackView(self,
                                    didTapInstrument: 1,
                                    atIndex: i * 8 + 4,
                                    drumID: drumIDs[1][i * 8 + 4])
            view.setActive(true)
        }
        for i in 0 ..< 32 {
            let view = drumBeatViews[2][i * 2]
            delegate?.drumTrackView(self,
                                    didTapInstrument: 2,
                                    atIndex: i * 2,
                                    drumID: drumIDs[2][i * 2])
            view.setActive(true)
        }
        delegate?.drumTrackView(self,
                                didTapInstrument: 0,
                                atIndex: 30,
                                drumID: drumIDs[0][30])
        drumBeatViews[0][30].setActive(true)
        delegate?.drumTrackView(self,
                                didTapInstrument: 1,
                                atIndex: 31,
                                drumID: drumIDs[1][31])
        drumBeatViews[1][31].setActive(true)
        delegate?.drumTrackView(self,
                                didTapInstrument: 0,
                                atIndex: 62,
                                drumID: drumIDs[0][62])
        drumBeatViews[0][62].setActive(true)
        delegate?.drumTrackView(self,
                                didTapInstrument: 1,
                                atIndex: 63,
                                drumID: drumIDs[1][63])
        drumBeatViews[1][63].setActive(true)
    }
}
