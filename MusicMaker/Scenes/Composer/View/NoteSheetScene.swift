//
//  NoteSheetScene.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import SpriteKit

class NoteSheetScene: SKScene {
    
    private var noteBlocks = [SKShapeNode]()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
    }
    
}
