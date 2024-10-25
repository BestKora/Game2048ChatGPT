//
//  Game.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 29.08.2024.
//

//import SwiftUI
import Foundation

struct Game {
    var tiles: [[Tile]] = []
    var score:Int = 0
    var isGameOver: Bool = false
    
    private var aiGame = AIGame()
    var algorithm: Algorithm = .Expectimax

    init() {
        resetGame()
    }
    
    mutating func resetGame() {
        score = 0
        isGameOver = false
        tiles = (0..<4).map { row in
                (0..<4).map { col in
                    Tile(value: 0, position: Position(row: row, col: col))
                }
            }
        addNewTile()
        addNewTile()
        }
   
    init(matrix: [[Tile]]) {
        self.tiles = matrix
        score = 0
        isGameOver = false
       }
    
    mutating func addNewTile() {
        let emptyPositions = tiles.flatMap { $0 }.filter { $0.value == 0 }

        // Check if there are no empty tiles available
        guard !emptyPositions.isEmpty else {
            return
        }

        // Select a random empty position
        let randomIndex = Int.random(in: 0..<emptyPositions.count)
        let randomPosition = emptyPositions[randomIndex].position

        // Determine whether to place a 2 or a 4, with a 90% chance of placing a 2
        let newValue = Double.random(in: 0..<1) < 0.9 ? 2 : 4

        // Update the tiles array with the new tile
        tiles[randomPosition.row][randomPosition.col] =  Tile(value: newValue, position: randomPosition)
    }

    private mutating func rotateLeft() {
         tiles = (0..<4).map { col in
             (0..<4).map { row in
                var tile = tiles[row][3 - col]
                 tile.position = Position(row: col, col: row)
                 return tile
             }
         }
     }

    private mutating func rotateRight() {
         tiles = (0..<4).map { col in
             (0..<4).map { row in
                 var tile = tiles[3 - row][col]
                 tile.position = Position(row: col, col:  row)
                 return tile
             }
         }
     }
    
    mutating func rotateRightTwice() {
        tiles = (0..<4).map { row in
            (0..<4).map { col in
                var tile = tiles[3 - row][3 - col]
                tile.position = Position(row: row, col: col)
                return tile
            }
        }
    }
    
    private func compressRow(_ row: [Tile]) -> [Tile] {
    /*    let canSlide =
        zip(row.dropFirst(), row).contains { $0.value != 0 && $1.value == 0 }
        
        guard canSlide else {return row}*/
        let nonZeroTiles = row.filter { $0.value != 0 }

       // Guard to check if we need to compress
      guard !nonZeroTiles.isEmpty, nonZeroTiles.count != 4,
              !(nonZeroTiles.count == 1 && nonZeroTiles.first?.position.col == 0) else {
            // If the row is already in a compressed state, return it as is
            return row
        }

        // Create new row with non-zero tiles and update their positions
        let newRow: [Tile] = nonZeroTiles.enumerated().map { (index, tile) in
            var updatedTile = tile
            updatedTile.position = Position(row: tile.position.row, col: index)
            return updatedTile
        }

        // Add zeros to the end of the row with updated positions
        let zeros = (newRow.count..<row.count).map { colIndex in
            Tile(value: 0, position: Position(row: row.first?.position.row ?? 0, col: colIndex))
        }

        return newRow + zeros
    }

    private func canMoveLeft(_ row: [Tile]) -> Bool {
        // Condition 1: Check if any tile can slide left (i.e., a non-zero tile has a zero before it)
        let canSlide =
        zip(row.dropFirst(), row).contains { $0.value != 0 && $1.value == 0 }
        
        // Condition 2: Check if any adjacent tiles can be merged
        let canMerge =
        zip(row.dropFirst(), row).contains { $0.value != 0 && $0.value == $1.value }
        
        return canSlide || canMerge
    }
    
    //------------------- SLIDE ---------------
    mutating func slide(_ direction: Direction) -> (moved: Bool, score: Int) {
        var moved = false
        var totalScore = 0

        // Rotate the board so we can always handle the move as a "left" move
        switch direction {
        case .up:
            rotateLeft()
        case .down:
            rotateRight()
        case .right:
           rotateRightTwice()
        case .left:
            break
        }

        for i in 0..<4 {
            let row = tiles[i]
           
            if canMoveLeft(row) {  //  --- Move a line of tiles left (compress and merge)
                let compressedRow = compressRow(row)
                let (mergedRow, scoreRow) = mergeRow(compressedRow)
                totalScore += scoreRow
                
                if mergedRow != row {
                    moved = true
                        tiles[i] = mergedRow
                }
            }
        }

        switch direction {
        case .up:
            rotateRight()
        case .down:
            rotateLeft()
        case .right:
             rotateRightTwice()
        case .left:
            break
        }
        
        return (moved, totalScore)
    }
    
    private func mergeRow(_ row: [Tile]) -> ([Tile], Int) {
        var newRow = row
        var scoreToAdd = 0

       let nonZeroTiles = row.filter { $0.value != 0 }
        
       // If the row has less than 2 tiles return it as is
        guard nonZeroTiles.count > 1 else {
            return (row, scoreToAdd)
        }

        for i in 0..<row.count - 1 {
            if newRow[i].value != 0 && newRow[i].value == newRow[i + 1].value {
                
                // Merge tiles
                newRow[i].value *= 2
                scoreToAdd += newRow[i].value
                
                // Change the id
                newRow[i].id = newRow[i + 1].id
                
                // New zero tile on i + ! position
                newRow[i + 1] = Tile(value: 0, position: Position(row: newRow[i].position.row, col: i + 1))
            }
        }

        // Compress the row after merging
        return (compressRow(newRow), scoreToAdd)
    }
    
    mutating func move(_ direction: Direction) {
        let (moved, score) = slide(direction)
        
        if moved {
            self.score += score
            addNewTile()
        }
        checkGameOver()
    }
    //--------------------------
    func bestMoveDirection() -> Direction {
        
        switch algorithm {
        case .Greedy: return aiGame.greedy(matrix: tiles)
        case .Expectimax: return aiGame.expectimax(depth: 4, matrix: tiles)
        case .Expectimax1: return aiGame.expectimax1(depth: 4, matrix: tiles)
        case .MonteCarlo: return aiGame.monteCarlo(depth: 6, matrix: tiles)// 
        case .MonteCarloAsync: return .up // фиктивное значение, реальное считается в bestMoveDirectionMonteCarloAsync
        }
        
    }
    
    func bestMoveDirectionMonteCarloAsync() async -> Direction {
        let direction = await aiGame.monteCarloAsync(depth: 8, matrix: tiles)
        return direction
    }
    
    func bestMoveDirectionExpectimaxAsync() async -> Direction {
        let direction = await aiGame.bestExpectimaxAsync(depth: 5, matrix: tiles)
        return direction
    }
    
    mutating func executeAIMove() {
        var  bestDirection : Direction
        guard !isGameOver else { return }
       // bestDirection = bestMoveDirection1()
          bestDirection = bestMoveDirection()
          move(bestDirection)
        }
        
   mutating func checkGameOver() {
            // Logic to check if the game is over
            if !canMove() {
                isGameOver = true
            }
        }
        
   func canMove() -> Bool {
        // Logic to determine if there are any valid moves left
        let grid = tiles.map{$0.map{$0.value}}
        for row in 0..<4 {
            for col in 0..<4 {
                if grid[row][col] == 0 {
                    return true
                }
                if row < 3 && grid[row][col] == grid[row + 1][col] {
                    return true
                }
                if col < 3 && grid[row][col] == grid[row][col + 1] {
                    return true
                }
            }
        }
        return false
    }
         /*   return Direction.allCases.contains { direction in
               aiGame.oneStepGame(direction: direction, matrix: tiles).moved
           }
        }*/
    //--------------------------------------
    func printBoard() {
        for row in 0..<4{
            let newRow:[Int] = tiles[row].map{ $0.value}
            print(newRow)
        }
    }
}
//---------------------------------- Second Variant BestMoveDirection1 --------
extension Game {
    
    func calculateScoreForMove(_ direction: Direction) -> (moved: Bool, score:Int ){
        var simulatedTiles = tiles.map{$0.map{$0.value}}
        var scoreIncrease = 0
        var moved = false
        
        switch direction {
        case .left:
            for row in 0..<4 {
                let (newRow, score) = simulateMergeRow(simulatedTiles[row])
                if simulatedTiles[row] != newRow {
                    moved = true
                }
                scoreIncrease += score
            }
        case .right:
            for row in 0..<4 {
                let (newRow, score) = simulateMergeRow(simulatedTiles[row].reversed())
                if simulatedTiles[row].reversed() != newRow {
                    moved = true
                }
                scoreIncrease += score
            }
        case .up:
            simulatedTiles = rotateLeft(simulatedTiles)
            for row in 0..<4 {
                let (newRow, score) = simulateMergeRow(simulatedTiles[row])
                if simulatedTiles[row] != newRow {
                    moved = true
                }
                scoreIncrease += score
            }
        case .down:
            simulatedTiles = rotateLeft(simulatedTiles)
            for row in 0..<4 {
                let (newRow, score) =
                simulateMergeRow(simulatedTiles[row].reversed())
                if simulatedTiles[row].reversed() != newRow {
                    moved = true
                }
                scoreIncrease += score
            }
        }
        
        return (moved,scoreIncrease)
    }
    
    private func simulateMergeRow(_ row: [Int]) ->  ([Int], Int) {
        var newRow = simulateCompress (row)
        var scoreIncrease = 0
        
        for i in 0..<newRow.count - 1 {
            if newRow[i] != 0 && newRow[i] == newRow[i + 1]{
                newRow[i] *= 2
                scoreIncrease += newRow[i]
                newRow[i + 1] = 0
            }
        }
        
        newRow = simulateCompress(newRow)
        return (newRow, scoreIncrease)
        
    }
    
    private func rotateLeft(_ grid: [[Int]]) -> [[Int]] {
        var rotatedGrid = grid
        for row in 0..<4 {
            for col in 0..<4 {
                rotatedGrid[3 - col][row] = grid[row][col]
            }
        }
        return rotatedGrid
    }
    
    // Compress: Move all non-zero tiles to the left
    func simulateCompress(_ line: [Int]) -> [Int] {
        let filtered = line.filter { $0 != 0 }
        let padding = Array(repeating: 0, count: 4 - filtered.count)
        return filtered + padding
        
    }
    private func simulateMove(_ direction: Direction) -> (moved: Bool, score: Int){
        let newBoard = tiles
        var model = Game()
        model.tiles = newBoard
        let result = model.slide(direction)
        return result
    }
    func bestMoveDirection1() -> Direction {
        
        var bestDirection: Direction = .right
        var maxScoreIncrease = 0
        
        for direction in Direction.allCases {
            let (moved,scoreIncrease)  = calculateScoreForMove(direction)
            if moved && scoreIncrease >= maxScoreIncrease {
                maxScoreIncrease = scoreIncrease
                bestDirection = direction
            }
        }
        
        return bestDirection
    }
}
//---------------------------------- Second Variant BestMoveDirection
