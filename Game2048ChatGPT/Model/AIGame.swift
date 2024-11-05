//
//  AIGame.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 26.08.2024.
//

import Foundation

struct AIGame {
    // Method to simulate one step of the game in a given direction
    func oneStepGame(direction: Direction, matrix: [[Tile]]) -> (moved: Bool, score: Int){
        var game = Game (matrix: matrix) // Initialize Game
      //  game.tiles = matrix
        // Call the slide method on Game
        let result = game.slide(direction)

        // Return the result from the slide method
        return result
    }
    
    // MARK: - Greedy
    func greedy (matrix: [[Tile]]) -> Direction {
        var bestDirection: Direction = .right
        var maxScore = 0
            
            for direction in Direction.allCases {
                let (moved, score) = oneStepGame(direction: direction, matrix: matrix)// simulateMove(direction)
                
                if moved && score >= maxScore {
                    maxScore = score
                    bestDirection = direction
                }
            }
        return bestDirection
          
    }
     
    // MARK: - Expectimax
    func expectimax(depth: Int, matrix: [[Tile]]) -> Direction {
        var bestDirection = Direction.right
        var bestScore: Double = -Double.infinity
        let emptyTilesCount = matrix.flatMap { $0 }.filter { $0.value == 0 }.count

       // for move in possibleMoves {
        for direction in Direction.allCases {
            var model = Game (matrix: matrix) // Initialize Game
            let (moved, _ ) = model.slide(direction)
            if moved {
                let newScore = expectimaxScore (board: model.tiles, depth: emptyTilesCount >= 4 ? depth - 1 : depth, isAITurn: false)
                if newScore > bestScore {
                    bestScore = newScore
                    bestDirection = direction
                }
            }
        }
        return bestDirection
    }
    
    // MARK: - Expectimax Score
    func expectimaxScore(board: [[Tile]], depth: Int, isAITurn: Bool) -> Double {
        // Base case: return the board evaluation if depth is 0 or game is over
       
        if depth == 0 || isGameOver (board.map {$0.map{$0.value}}){
            return evaluateBoard(board)
        }
        
        // AI's move (maximize the score)
        if isAITurn {
            var maxScore = -Double.infinity
            for direction in Direction.allCases {
                var game = Game (matrix: board) // Initialize Game
                let (moved, _ ) = game.slide( direction)
                if moved {
                    // Recur for the next move, but now it's the tile placement's turn
                    maxScore = max(maxScore, expectimaxScore(board: game.tiles, depth: depth - 1, isAITurn: false))
                }
            }
            return maxScore
        }
        // Random tile placement's move (chance node)
        else {
            var expectedScore = 0.0
            let emptyTiles = board.flatMap { $0 }.filter { $0.value == 0 }

            // If no empty tiles, the game is over
            if emptyTiles.isEmpty {
               // return evaluateBoard(board.map {$0.map{$0.value}})
                  return evaluateBoard(board)
            }

            // For each empty tile, calculate the expected value
            for tile in emptyTiles {
                var boardWith2 =  board
                boardWith2[tile.position.row][tile.position.col].value = 2
                var boardWith4 = board
                boardWith4[tile.position.row][tile.position.col].value = 4

                // 90% probability of placing a '2' tile, 10% of placing a '4' tile
                expectedScore += 0.9 * expectimaxScore(board: boardWith2, depth: depth - 1, isAITurn: true)
                expectedScore += 0.1 * expectimaxScore(board: boardWith4, depth: depth - 1, isAITurn: true)
            }
            return expectedScore / Double(emptyTiles.count)
        }
    }
    
    // MARK: - isGameOver
    private func isGameOver(_ grid: [[Int]]) -> Bool {
            for row in 0..<4 {
                for col in 0..<4 {
                    if grid[row][col] == 0 {
                        return false
                    }
                    if row < 3 && grid[row][col] == grid[row + 1][col] {
                        return false
                    }
                    if col < 3 && grid[row][col] == grid[row][col + 1] {
                        return false
                    }
                }
            }
            return true
        }
   
    // MARK: - evaluateBoard
    private func evaluateBoard (_ board: [[Tile]]) -> Double {
        let grid = board.map {$0.map{$0.value}}
        let emptyCells = board.flatMap { $0 }.filter { $0.value == 0 }.count
            
        let smoothWeight: Double = 0.1
            let monoWeight: Double = 1.0
            let emptyWeight: Double = 11.7
            let maxWeight: Double = 1.0
         //   let maxTileCornerWeight = 1.0
        
     //   print ("smoth = \(smoothWeight * smoothness(grid)) mono = \(monoWeight * monotonicity(grid)) empty = \(emptyWeight * Double(emptyCells)) max = \(maxWeight * Double(grid.flatMap { $0 }.max() ?? 0)) snake = \(snakeHeuristic(grid))")
            
            return monoWeight *  monotonicity(grid)
         //        + smoothWeight * smoothness(grid)
                 + emptyWeight * Double(emptyCells)
                 + maxWeight * Double(grid.flatMap { $0 }.max() ?? 0)
             //    + maxTileCornerWeight * maxTileInCorner(board)
                 + snakeHeuristic(grid)
        }
    
    // MARK: - maxTileInCorner
    func maxTileInCorner(_ board: [[Tile]]) -> Double {
        let maxTile = board.flatMap { $0 }.max(by: { $0.value < $1.value })?.value ?? 0
        let cornerTiles = [
            board[0][0], board[0][3],
            board[3][0], board[3][3]
        ]
        return cornerTiles.contains(where: { $0.value == maxTile }) ? 1.0 : 0.0
    }

    // MARK: - smoothness
      func smoothness(_ grid: [[Int]]) -> Double {
            var smoothness: Double = 0
            for row in 0..<4 {
                for col in 0..<4 {
                    if grid[row][col] != 0 {
                        let value = Double(grid[row][col])
                        if col < 3 && grid[row][col+1] != 0 {
                            smoothness -= abs(value - Double(grid[row][col+1]))
                        }
                        if row < 3 && grid[row+1][col] != 0 {
                            smoothness -= abs(value - Double(grid[row+1][col]))
                        }
                    }
                }
            }
            return smoothness
        }
        
    // MARK: - monotonicity
        func monotonicity(_ grid: [[Int]]) -> Double {
            var totals: [Double] = [0, 0, 0, 0]
            
            for i in 0..<4 {
                var current = 0
                var next = current + 1
                while next < 4 {
                    while next < 4 && grid[i][next] == 0 {
                        next += 1
                    }
                    if next >= 4 {
                        next -= 1
                    }
                    let currentValue = grid[i][current] != 0 ? log2(Double(grid[i][current])) : 0
                    let nextValue = grid[i][next] != 0 ? log2(Double(grid[i][next])) : 0
                    if currentValue > nextValue {
                        totals[0] += nextValue - currentValue
                    } else if nextValue > currentValue {
                        totals[1] += currentValue - nextValue
                    }
                    current = next
                    next += 1
                }
            }
            
            for i in 0..<4 {
                var current = 0
                var next = current + 1
                while next < 4 {
                    while next < 4 && grid[next][i] == 0 {
                        next += 1
                    }
                    if next >= 4 {
                        next -= 1
                    }
                    let currentValue = grid[current][i] != 0 ? log2(Double(grid[current][i])) : 0
                    let nextValue = grid[next][i] != 0 ? log2(Double(grid[next][i])) : 0
                    if currentValue > nextValue {
                        totals[2] += nextValue - currentValue
                    } else if nextValue > currentValue {
                        totals[3] += currentValue - nextValue
                    }
                    current = next
                    next += 1
                }
            }
        //    print (totals)
            return max(totals[0], totals[1]) + max(totals[2], totals[3])
        }
    
    // MARK: - monotonicity1
    func monotonicity1(_ board: [[Int]]) -> Double {
        // The same as monotonicity2
        
        let grid:[[Int]] = board.map{$0.map{ $0 != 0 ? Int(log2(Double($0))): 0}}
        func monotonicityScore(_ arr: [Int]) -> (Double, Double) {
            let arrNonZero = arr.filter { $0 != 0 }
    
            let increasingScore = zip(arrNonZero, arrNonZero.dropFirst()).filter {$0 >= $1}.map {Double($1 - $0) }.reduce(0.0, +)
            let decreasingScore = zip(arrNonZero, arrNonZero.dropFirst()).filter {$0 <= $1}.map {Double($0 - $1) }.reduce(0.0, +)
            return (increasingScore, decreasingScore)
        }
        
        let rowScores = grid.map(monotonicityScore)
        let rowIncreasing = rowScores.map {$0.0}
        let rowDecreasing = rowScores.map {$0.1}
        
        let columns = (0..<grid[0].count).map { col in grid.map { $0[col] } }
        let columnScores = columns.map(monotonicityScore)
        let columnIncreasing = columnScores.map {$0.0}
        let columnDecreasing = columnScores.map {$0.1}
        
        let totalScore = max (rowIncreasing.reduce(0.0, +), rowDecreasing.reduce(0.0, +)) + max (columnIncreasing.reduce(0.0, +), columnDecreasing.reduce(0.0, +))
        return totalScore
    }
    
    // MARK: - monotonicity2
    func monotonicity2(_ grid: [[Int]]) -> Double {
        func calculateMonotonicity(values: [Int]) -> (Double, Double) {
            var increasing = 0.0
            var decreasing = 0.0
            var current = 0

            // Skip over any initial zeros in the row/column
            while current < values.count && values[current] == 0 {
                current += 1
            }

            var next = current + 1

            while next < values.count {
                // Skip over any zeros in the middle
                while next < values.count && values[next] == 0 {
                    next += 1
                }

                if next < values.count {
                    let currentValue = values[current] != 0 ? log2(Double(values[current])) : 0
                    let nextValue = values[next] != 0 ? log2(Double(values[next])) : 0

                    if currentValue > nextValue {
                        decreasing += nextValue - currentValue
                    } else if currentValue < nextValue {
                        increasing += currentValue - nextValue
                    }

                    // Move to the next non-zero tile
                    current = next
                    next += 1
                }
            }

            return (increasing, decreasing)
        }

        var rowMonotonicity = (increasing: 0.0, decreasing: 0.0)
        var colMonotonicity = (increasing: 0.0, decreasing: 0.0)

        // Check row monotonicity (left-right)
        for row in grid {
            let (increasing, decreasing) = calculateMonotonicity(values: row)
            rowMonotonicity.increasing += increasing
            rowMonotonicity.decreasing += decreasing
          //  print (rowMonotonicity)
        }

        // Check column monotonicity (up-down)
        for col in 0..<grid[0].count {
            let columnValues = grid.map { $0[col] }
            let (increasing, decreasing) = calculateMonotonicity(values: columnValues)
            colMonotonicity.increasing += increasing
            colMonotonicity.decreasing += decreasing
         //   print (colMonotonicity)
        }

        return max(rowMonotonicity.increasing, rowMonotonicity.decreasing) +
               max(colMonotonicity.increasing, colMonotonicity.decreasing)
    }

    
    // MARK: - bonus for snake heuristic positions of numbers
    func snakeHeuristic (_ grid: [[Int]]) -> Double {
        let perfectSnake1 : [[Double]] = [
            [ pow (4, 0),  pow (4, 1), pow (4, 2), pow (4, 3)],
            [ pow (4, 7),  pow (4, 6), pow (4, 5), pow (4, 4)],
            [ pow (4, 8),  pow (4, 9),pow (4, 10),pow (4, 11)],
            [ pow (4, 15), pow (4, 14),pow (4, 13),pow (4, 12)]
        ]
        let perfectSnake: [[Double]] = [
            [ pow (2, 1),  pow (2, 2), pow (2, 3), pow (2, 4)],
            [ pow (2, 8),  pow (2, 7), pow (2, 6), pow (2, 5)],
            [ pow (2, 9),  pow (2, 10),pow (2, 11),pow (2, 12)],
            [ pow (2, 16), pow (2, 15),pow (2, 14),pow (2, 13)]
        ]
        var h = 0.0
        for i in 0..<4 {
            for j in 0..<4 {
                h = h + Double(grid[i][j]) * perfectSnake[i][j]
            }
        }
        return h
    }
    
    //=======================
    // MARK: -  Expectimax 1 AI
    func expectimax1 (depth: Int, matrix: [[Tile]]) -> Direction {
        var bestDirection = Direction.right
        var bestScore: Double = -Double.infinity
        let emptyTilesCount = matrix.flatMap { $0 }.filter { $0.value == 0 }.count

       // for move in possibleMoves {
        for direction in Direction.allCases {
            var model = Game (matrix: matrix) // Initialize Game
          //  let (moved, _ ) = model.slide(move)
            let (moved, _ ) = model.slide(direction)
            if moved {
                let newScore = expectimax1Score (grid: model.tiles, depth: emptyTilesCount >= 4 ? depth - 1 : depth ,  isAITurn: false)
                if newScore > bestScore {
                    bestScore = newScore
                   // bestMove = move
                    bestDirection = direction
                }
            }
        }
        return bestDirection
    }
        
    // MARK: - expectimax1Score
    func expectimax1Score(grid: [[Tile]], depth: Int,  isAITurn: Bool) -> Double {
            // Base case: return the board evaluation if depth is 0 or game is over
           
            if depth == 0 || isGameOver (grid.map {$0.map{$0.value}}){
              // return evaluateBoard(grid.map {$0.map{$0.value}})
                return evaluateBoard(grid)
            }
            
            // AI's move (maximize the score)
            if isAITurn {
                var maxScore = -Double.infinity
                for direction in Direction.allCases {
                   
                        var game = Game (matrix: grid) // Initialize Game
                        let (moved, _ ) = game.slide( direction)
                        if moved {
                            // Recur for the next move, but now it's the tile placement's turn
                            let newScore = expectimax1Score(grid: game.tiles, depth: depth - 1, isAITurn: false)
                            maxScore = max(maxScore, newScore)
                        }
                }
                return maxScore
            }
            // Random tile placement's move (chance node)
            else {
                var expectedScore = 0.0
                let emptyTiles = grid.flatMap { $0 }.filter { $0.value == 0 }

                // If no empty tiles, the game is over
                if emptyTiles.isEmpty {
                 //  return evaluateBoard(grid.map {$0.map{$0.value}})
                    return evaluateBoard(grid)
                }

                // For each empty tile, calculate the expected value
                for tile in emptyTiles {
                    var boardWith2 = grid
                          boardWith2[tile.position.row][tile.position.col].value = 2
                    var boardWith4 = grid
                          boardWith4[tile.position.row][tile.position.col].value = 4

                    // 90% probability of placing a '2' tile, 10% of placing a '4' tile
                    expectedScore += 0.9 * expectimax1Score(grid: boardWith2, depth: depth - 1, isAITurn: true)
                    expectedScore += 0.1 * expectimax1Score(grid: boardWith4, depth: depth - 1, isAITurn: true)
                }
                return expectedScore / Double(emptyTiles.count)
            }
        }
    
    // MARK: RANDOMGAME strategy
    
    // MARK: - monteCarlo
    func monteCarlo(depth: Int, matrix: [[Tile]]) -> Direction {
        var scores: [Direction: Int] = [.up: 0, .down: 0, .left: 0, .right: 0]
            
        //------
        for direction in Direction.allCases{
           let  (moved, _) =  oneStepGame(direction: direction, matrix: matrix)
            if moved {
                let  (_ , score) = monteCarloSimulation(direction: direction, matrix: matrix)
                scores[direction, default: 0] += score
            }
        }
            return scores.max(by: { $0.value < $1.value })?.key ?? .up
        }
    
    // MARK: - monteCarloSimulation
    func monteCarloSimulation(direction: Direction,matrix:[[Tile]]) -> (moved:Bool, score:Int){
        let simulations = 150
        let depth =  15
        let limitZeros =  4 // 6
        var scores = [Int]()
        
        var sum = 0
        var scoreOneGame = 0
        
        let gameBoard = Game(matrix: matrix)
        let zerosNumber = gameBoard.tiles.flatMap { $0 }.filter { $0.value == 0 }.count
        for _ in 0..<simulations {
           if zerosNumber <= limitZeros {
               scoreOneGame = randomGameEnd(direction: direction, matrix: matrix)
                scores.append(scoreOneGame)
            } else {
                scoreOneGame = randomGame(direction: direction, matrix: matrix, depth: depth)
                scores.append(scoreOneGame)
           }
            sum = sum + scoreOneGame
        }
        return (moved: true, score: scores.average() )
    }
    
    // MARK: - randomGame
    func randomGame(direction: Direction, matrix:[[Tile]], depth: Int) -> Int {
        var sum = 0
        var gameBoard = Game(matrix: matrix)
  
        let result = gameBoard.slide(direction)
        if  result.moved {
            gameBoard.addNewTile()
            gameBoard.score = result.score
        } else {
            return sum
        }
        for _ in 0..<depth {
                let rndDirection = Direction.randomDirection()
                gameBoard.move(rndDirection)
            }
        sum = gameBoard.score

            // ---- bonus for zeros -------
        let bonus = gameBoard.tiles.flatMap { $0 }.filter { $0.value == 0 }.count * 8092 * 2
        return sum + bonus
    }
    
    // MARK: - randomGameEnd
    func randomGameEnd(direction: Direction, matrix:[[Tile]]) -> Int {
        var sum = 0
        var gameBoard = Game(matrix: matrix)
  
        let result = gameBoard.slide(direction)
        if  result.moved {
            gameBoard.addNewTile()
            gameBoard.score = result.score
        } else {
            return sum
        }
        while !gameBoard.isGameOver{
                let rndDirection = Direction.randomDirection()
                gameBoard.move(rndDirection)
            }
        sum = gameBoard.score
       // let grid = gameBoard.tiles.map {$0.map{$0.value}}
        return sum //+ (grid.flatMap { $0}.max() ?? 0)
    }
    
    // MARK: - monteCarloSimulationParallel
    // Parallell calculation attempt
    func monteCarloSimulationParallel (direction: Direction,matrix:[[Tile]]) async -> Int {
        var simulations = 180//150
        let depth =  20//15
        let limitZeros =  4 //6
        var scores = [Int]()
    
        let gameBoard = Game(matrix: matrix)
    //    guard !isGameOver (matrix.map {$0.map{$0.value}}) else {return 0}
        
        let zerosNumber = gameBoard.tiles.flatMap { $0 }.filter { $0.value == 0 }.count
        //var depthNew = zerosNumber <= limitZeros ? 20: 15
        simulations = zerosNumber <= limitZeros ? 150: 180
        await withTaskGroup(of: Int.self) { group in
            for _ in 0..<simulations {
                group.addTask {
                   if zerosNumber <= limitZeros {
                       return randomGameEnd(direction: direction, matrix: matrix)
                      //  return  randomGame(direction: direction, matrix: matrix, depth: depth  )
                   } else {
                       return  randomGame(direction: direction, matrix: matrix, depth: depth )
                    }
                }
            }
            // Collect results as tasks complete
                    for await score in group {
                        scores.append(score)
                    }
        }
        return scores.average()
    }
    
    // MARK: - monteCarloAsync
    func monteCarloAsync(depth: Int, matrix: [[Tile]]) async -> Direction {
        var scores: [Direction: Int] = [.up: 0, .down: 0, .left: 0, .right: 0]
        
        //------
        for direction in Direction.allCases{
            let  (moved, _) =  oneStepGame(direction: direction, matrix: matrix)
            if moved {
                let  score = await monteCarloSimulationParallel     (direction: direction, matrix: matrix)
                scores[direction, default: 0] += score
            }
        }
       //     print ("\(scores)  direction = \(scores.max(by: { $0.value < $1.value })?.key ?? .up)")
        return scores.max(by: { $0.value < $1.value })?.key ?? .up
    }
    
    // MARK: - expectimaxAsync

    // Asynchronous expectimax algorithm with improved parallelism
    func expectimaxAsyn(grid: [[Tile]], depth: Int, isAITurn: Bool) async -> Double {
        
        // Base case: return the board evaluation if depth is 0 or game is over
        if depth == 0 || isGameOver (grid.map {$0.map{$0.value}}){
          // return evaluateBoard(grid.map {$0.map{$0.value}})
            return evaluateBoard(grid)
        }

        if isAITurn {
            //------
            // Player's turn (maximize the score)
            var maxScore = -Double.infinity
            
            // Use task group for parallel evaluation of all directions
            return await withTaskGroup(of: Double.self) { group in
                for direction in Direction.allCases {
                    group.addTask {
                        var game = Game (matrix: grid) // Initialize Game
                        let (moved, _) = game.slide( direction)
                        if moved {
                            return await expectimaxAsyn (grid: game.tiles, depth: depth - 1, isAITurn: false)
                        }
                        return -Double.infinity
                    }
                }
                
                for await result in group {
                    maxScore = max(maxScore, result)
                }
                return maxScore
            }
            //------
           
        } else {
            // AI's turn (chance node)
        //    var expectedScore = 0.0
            let emptyTiles = grid.flatMap { $0 }.filter { $0.value == 0 }

            // If no empty tiles, the game is over
            if emptyTiles.isEmpty {
             //  return evaluateBoard(grid.map {$0.map{$0.value}})
                return evaluateBoard(grid)
            }
            // Limit parallelism at deeper levels to avoid overwhelming system
            if depth > 4 {//3 {
                var expectedValue = 0.0
                for tile in emptyTiles {
                    var boardWith2 = grid
                        boardWith2[tile.position.row][tile.position.col].value = 2
                    let valueFor2 = await expectimaxAsyn(grid: boardWith2, depth: depth - 1, isAITurn: true)
                    
                    var boardWith4 = grid
                          boardWith4[tile.position.row][tile.position.col].value = 4
                    let valueFor4 = await expectimaxAsyn(grid: boardWith4, depth: depth - 1, isAITurn: true)

                    expectedValue += 0.9 * valueFor2 + 0.1 * valueFor4
                }
                return expectedValue / Double(emptyTiles.count)
            } else {
                // Use task group for parallel execution in shallower levels
                return await withTaskGroup(of: Double.self) { group in
                    var expectedValue = 0.0
                    for tile in emptyTiles {
                        group.addTask {
                            var boardWith2 = grid
                                boardWith2[tile.position.row][tile.position.col].value = 2
                            return await expectimaxAsyn(grid: boardWith2, depth: depth - 1, isAITurn: true) * 0.9
                        }
                        group.addTask {
                            var boardWith4 = grid
                                  boardWith4[tile.position.row][tile.position.col].value = 4
                            return await expectimaxAsyn(grid: boardWith4, depth: depth - 1, isAITurn: true) * 0.1
                        }
                    }
                    
                    for await result in group {
                        expectedValue += result
                    }
                    return expectedValue / Double(emptyTiles.count)
                }
            }
        }
    }
    
    //=======================
    // MARK: -  ExpectimaxAsync AI
    func bestExpectimaxAsync (depth: Int, matrix: [[Tile]]) async -> Direction {
        var bestDirection = Direction.right
        var bestScore: Double = -Double.infinity
        let emptyTilesCount = matrix.flatMap { $0 }.filter { $0.value == 0 }.count
       
       // for move in possibleMoves {
        for direction in Direction.allCases {
            var model = Game (matrix: matrix) // Initialize Game
          //  let (moved, _ ) = model.slide(move)
            let (moved, _ ) = model.slide(direction)
            if moved {
                let newScore = await expectimaxAsyn (grid: model.tiles, depth: emptyTilesCount >= 4 ? depth - 1 : depth ,  isAITurn: false)
                if newScore > bestScore {
                    bestScore = newScore
                   // bestMove = move
                    bestDirection = direction
                }
            }
        }
        return bestDirection
    }
    //-------------------------
   
} // AIGame


