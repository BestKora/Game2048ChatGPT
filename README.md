# Game 2048 with AI algorithms Expectimax and Monte Carlo

##  Expectimax AI.............................. Monte Carlo AI

<img src="https://github.com/BestKora/Game2048ChatGPT/blob/c7ea253ac4ed9b4882deff1a1ba2fa9e2a4813b7/Record%20Expectimax1%20143%20436%20.gif" width="250"/> <img src="https://github.com/BestKora/Game2048ChatGPT/blob/fb233c1f0c7e832a8a7e3fa5d64239cc5917fb73/Record%20Monte%20Carlo%20Async%2070%20108%20.gif" width="264"/>

## This is the beginning of a dialogue with ChatGPT:
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
![](https://github.com/BestKora/Game2048ChatGPT/blob/364d82ecc041215d2872a2b9e35a1073985c9efb/Dialog3.png)
```swift
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Text("2048")
                .font(.largeTitle)
                .padding()
            
            GridView(board: viewModel.board)
                .padding()
            
            Button(action: {
                // Implement restart functionality
                viewModel.resetGame()
            }) {
                Text("Restart")
                    .font(.title2)
                    .padding()
            }
        }
        .onAppear {
            // Initialize game state
        }
    }
}

struct GridView: View {
    let board: [[Int]]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<4) { row in
                HStack(spacing: 10) {
                    ForEach(0..<4) { col in
                        TileView(value: board[row][col])
                    }
                }
            }
        }
    }
}

struct TileView: View {
    let value: Int

    var body: some View {
        Text(value == 0 ? "" : "\(value)")
            .frame(width: 70, height: 70)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .font(.title)
            .foregroundColor(.black)
    }
}
```
![](https://github.com/BestKora/Game2048ChatGPT/blob/364d82ecc041215d2872a2b9e35a1073985c9efb/Dialog4.png)
```swift
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Text("2048")
                .font(.largeTitle)
                .padding()
            
            GridView(board: viewModel.board)
                .padding()
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let horizontalAmount = value.translation.width
                            let verticalAmount = value.translation.height
                            
                            if abs(horizontalAmount) > abs(verticalAmount) {
                                if horizontalAmount > 0 {
                                    viewModel.move(.right)
                                } else {
                                    viewModel.move(.left)
                                }
                            } else {
                                if verticalAmount > 0 {
                                    viewModel.move(.down)
                                } else {
                                    viewModel.move(.up)
                                }
                            }
                        }
                )
            
            Button(action: {
                viewModel.resetGame()
            }) {
                Text("Restart")
                    .font(.title2)
                    .padding()
            }
        }
     }
}
```
![](https://github.com/BestKora/Game2048ChatGPT/blob/364d82ecc041215d2872a2b9e35a1073985c9efb/Dialog5.png)
