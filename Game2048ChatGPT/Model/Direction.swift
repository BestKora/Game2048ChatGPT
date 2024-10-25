//
//  Direction.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import Foundation

enum Direction: CaseIterable {
    case down, up, right, left
    
    static var directions: [Direction] {
        [.up, .left, .right,.down]
    }
    
   static func randomDirection() -> Direction {
        let randomNumber = Int.random(in: 0..<directions.count)
        return directions[randomNumber]
    }
}
