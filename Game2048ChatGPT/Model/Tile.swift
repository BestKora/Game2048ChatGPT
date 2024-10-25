//
//  Tile.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 21.08.2024.
//

import SwiftUI

struct Position: Equatable {
    var row: Int
    var col: Int
}

struct Tile : Identifiable, Equatable, Comparable {
    
    static func < (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.value < rhs.value
    }
    
    var value: Int
    var position: Position
    var id = UUID()  // Conformance to Identifiable
  
     // Manually confirm Equable
     static func == (lhs: Tile, rhs: Tile) -> Bool {
         return lhs.value == rhs.value /*  && lhs.position == rhs.position  */
     
      }
   
}
