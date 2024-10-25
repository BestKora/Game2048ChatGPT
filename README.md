# Game 2048 with AI algorithms Expectimax and Monte Carlo

## It's Expectimax AI:
 
![](https://github.com/BestKora/Game2048ChatGPT/blob/c7ea253ac4ed9b4882deff1a1ba2fa9e2a4813b7/Record%20Expectimax1%20143%20436%20.gif)

## It's Monte Carlo AI:
![](https://github.com/BestKora/Game2048ChatGPT/blob/fb233c1f0c7e832a8a7e3fa5d64239cc5917fb73/Record%20Monte%20Carlo%20Async%2070%20108%20.gif)

## It's Dialog with ChatGPT:
![](https://github.com/BestKora/Game2048ChatGPT/blob/364d82ecc041215d2872a2b9e35a1073985c9efb/Dialog1.png)
![](https://github.com/BestKora/Game2048ChatGPT/blob/364d82ecc041215d2872a2b9e35a1073985c9efb/Dialog2.png)

```swift
import SwiftUI

enum Direction {
    case up, down, left, right
}

class GameViewModel: ObservableObject {
    @Published var board: [[Int]]
    @Published var gameOver = false

    init() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        addNewTile()
        addNewTile()
    }

    func addNewTile() {
        var emptyTiles: [(Int, Int)] = []
        for row in 0..<4 {
            for col in 0..<4 {
                if board[row][col] == 0 {
                    emptyTiles.append((row, col))
                }
            }
        }
        if let randomTile = emptyTiles.randomElement() {
            board[randomTile.0][randomTile.1] = Bool.random() ? 2 : 4
        }
    }

   func resetGame() {
        // Reset the board to the initial state
   }

    func move(_ direction: Direction) {
        // Implement the movement logic here
        // This will include merging tiles and updating the board state
        // After moving tiles, call addNewTile() to add a new tile
    }

    func checkGameOver() {
        // Implement the logic to check if the game is over
        // This will involve checking if there are any valid moves left
    }
}
```
