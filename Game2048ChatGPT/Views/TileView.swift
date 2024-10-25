//
//  TileView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import SwiftUI

struct TileView: View {
    let tile: Tile
    let tileSize: CGFloat
    let padding: CGFloat

    var body: some View {
        let tilePosition = getTilePosition()

       RoundedRectangle(cornerRadius:padding)
                    .fill(colorForTile(tile.value))
                    .frame(width: tileSize, height: tileSize)
                    .overlay(
                        Text(tile.value , format: .number.precision(.fractionLength(0)).grouping(.never))
                            .font(Font.system(size: fontSize))
                                .foregroundColor(tile.value > 4 ? .white : .black) // Adjust text color based on tile value

                    )
                    .position(tilePosition)
                    .animation(.easeInOut(duration: 0.2), value: tile.position) // Анимация перемещения плитки
                    .transition(.scale(scale: 0.12).combined(with:
                                .offset( x: tilePosition.x - 2 * tileSize,
                                         y: tilePosition.y - 2 * tileSize)))
                   
    }
    
    private func getTilePosition() -> CGPoint {
            let x = CGFloat(tile.position.col) * (tileSize + padding) + tileSize / 2
            let y = CGFloat(tile.position.row) * (tileSize + padding) + tileSize / 2

            return CGPoint(x: x, y: y)
        }
   
    
    private func colorForTile(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color(hex: "#EEE4DA") // Light beige
        case 4:
            return Color(hex: "#EDE0C8") // Beige
        case 8:
            return Color(hex: "#F2B179") // Light orange
        case 16:
            return Color(hex: "#F59563") // Orange
        case 32:
            return Color(hex: "#F67C5F") // Darker orange
        case 64:
            return Color(hex: "#F65E3B") // Dark orange-red
        case 128:
            return Color(hex: "#EDCF72") // Yellow
        case 256:
            return Color(hex: "#EDCC61") // Darker yellow
        case 512:
            return Color(hex: "#EDC850") // Gold
        case 1024:
            return Color(hex: "#EDC53F") // Dark gold
        case 2048:
            return Color(hex: "#EDC22E") // Bright gold
        default:
            return Color(hex: "#CDC1B4") // Default color (for empty or non-standard tiles)
        }
    }
    private var fontSize: CGFloat {
        switch String(tile.value).count {
        case let k where k < 4 && k > 0: return 32
        case let k where k == 4: return 28
        case let k where k > 4 && k < 6 : return 20
        default: return 18
        }
     }
}

#Preview {
    TileView(tile: Tile(value: 32, position: Position(row: 0, col: 0)), tileSize: 80, padding: 8)
        .padding()
}
