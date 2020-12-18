//
//  ViewController.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 24.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var noteSheetView: NoteSheetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        noteSheetView.addGestureRecognizer(UITapGestureRecognizer(target: self,
//                                                                  action: #selector(didTapNoteSheet(_:))))
    }
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        
    }
    
//    @objc private func didTapNoteSheet(_ sender: UITapGestureRecognizer) {
//
//    }
    
}

