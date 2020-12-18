//
//  Collection+Extensions.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.11.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

extension Collection where Self.Index == Int {
    
    func skip(_ number: Int) -> Array<Element> {
        var newArray = [Element]()
        let newCount = self.count / (number + 1)
        newArray.reserveCapacity(newCount)
        for i in 0 ..< newCount {
            newArray.append(self[i * (1 + number)])
        }
        return newArray
    }
    
}
