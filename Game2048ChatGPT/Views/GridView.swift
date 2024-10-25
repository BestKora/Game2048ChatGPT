//
//  GridView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import SwiftUI

//Define the GridView to use TileView
struct GridView: View {
    let tiles: [[Tile]]
    let tileSize: CGFloat
    let padding: CGFloat
    //-------------------
    let optimalDirection: Direction
    var isShowingOptimalDirection: Bool
    
    var body: some View {
        ZStack {
            // Background grid
            BackgroundView(tileSize: tileSize, padding: padding)
            // Foreground non-zero tiles
            ForEach(tiles.flatMap { $0 }.filter { $0.value != 0 }) { tile in
                TileView(tile: tile, tileSize: tileSize, padding: padding)
            }
            .padding()
            
            if isShowingOptimalDirection {
                OptimalDirectionView(direction: optimalDirection)
        //   OptimalDirectionArrow(direction: optimalDirection)
                    .padding()
            }
        }
        .frame(width: 4 * tileSize + 3 * padding, height: 4 * tileSize + 3 * padding) // Adjust frame size
    }
}

struct BackgroundView: View {
    
    let tileSize: CGFloat
    let padding: CGFloat
    
    var body: some View {
        // Background grid
        VStack(spacing: padding) {
            ForEach(0..<4) { row in
                HStack(spacing: padding) {
                    ForEach(0..<4) { col in
                        RoundedRectangle(cornerRadius:padding)
                            .fill(Color.colorEmpty)
                            .frame(width: tileSize, height: tileSize)
                    }
                }
            }
        }
        .padding()
        .background(Color.colorBG)
    }
}

#Preview {
    GridView(tiles:  [
        [Tile(value: 2, position: Position(row: 0, col: 0)), Tile(value: 0, position: Position(row: 0, col: 1)), Tile(value: 4, position: Position(row: 0, col: 2)), Tile(value: 0, position: Position(row: 0, col: 3))],
        [Tile(value: 0, position: Position(row: 1, col: 0)), Tile(value: 0, position: Position(row: 1, col: 1)), Tile(value: 16, position: Position(row: 1, col: 2)), Tile(value: 0, position: Position(row: 1, col: 3))],
        [Tile(value: 0, position: Position(row: 2, col: 0)), Tile(value: 2, position: Position(row: 2, col: 1)), Tile(value: 0, position: Position(row: 2, col: 2)), Tile(value: 8, position: Position(row: 2, col: 3))],
        [Tile(value: 4, position: Position(row: 3, col: 0)), Tile(value: 4, position: Position(row: 3, col: 1)), Tile(value: 0, position: Position(row: 3, col: 2)), Tile(value: 32, position: Position(row: 3, col: 3))]], tileSize: 80, padding: 8, optimalDirection: .down, isShowingOptimalDirection: false)
}
