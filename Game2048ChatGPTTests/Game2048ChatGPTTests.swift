//
//  Game2048ChatGPTTests.swift
//  Game2048ChatGPTTests
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import XCTest

@testable import Game2048ChatGPT

final class Game2048ChatGPTTests: XCTestCase {
    var game : Game!
    var aiGame: AIGame!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        game = Game()
        aiGame = AIGame()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSlideLeftWithoutMerging() {
        game.tiles/* viewModel.tiles */ = [
                [Tile(value: 2, position: Position(row: 0, col: 0)), Tile(value: 0, position: Position(row: 0, col: 1)), Tile(value: 4, position: Position(row: 0, col: 2)), Tile(value: 0, position: Position(row: 0, col: 3))],
                [Tile(value: 0, position: Position(row: 1, col: 0)), Tile(value: 0, position: Position(row: 1, col: 1)), Tile(value: 2, position: Position(row: 1, col: 2)), Tile(value: 0, position: Position(row: 1, col: 3))],
                [Tile(value: 0, position: Position(row: 2, col: 0)), Tile(value: 2, position: Position(row: 2, col: 1)), Tile(value: 0, position: Position(row: 2, col: 2)), Tile(value: 4, position: Position(row: 2, col: 3))],
                [Tile(value: 4, position: Position(row: 3, col: 0)), Tile(value: 4, position: Position(row: 3, col: 1)), Tile(value: 0, position: Position(row: 3, col: 2)), Tile(value: 2, position: Position(row: 3, col: 3))]
            ]
            
         //   let (moved, score) = viewModel.slide(.left)
         //     game = Game(matrix: tiles1)
        let (moved, score) = game.slide(.left)
            
            XCTAssertTrue(moved)
            XCTAssertEqual(score, 8)
            XCTAssertEqual(game.tiles[0][0].value, 2)
            XCTAssertEqual(game.tiles[0][1].value, 4)
            XCTAssertEqual(game.tiles[0][2].value, 0)
            XCTAssertEqual(game.tiles[0][3].value, 0)
            XCTAssertEqual(game.tiles[3][0].value, 8)
            XCTAssertEqual(game.tiles[3][1].value, 2)
            XCTAssertEqual(game.tiles[3][2].value, 0)
            XCTAssertEqual(game.tiles[3][3].value, 0)
        }
        
        func testSlideRightWithMerging() {
            game.tiles /*viewModel.tiles*/ = [
                [Tile(value: 2, position: Position(row: 0, col: 0)), Tile(value: 2, position: Position(row: 0, col: 1)), Tile(value: 4, position: Position(row: 0, col: 2)), Tile(value: 4, position: Position(row: 0, col: 3))],
                [Tile(value: 0, position: Position(row: 1, col: 0)), Tile(value: 2, position: Position(row: 1, col: 1)), Tile(value: 0, position: Position(row: 1, col: 2)), Tile(value: 2, position: Position(row: 1, col: 3))],
                [Tile(value: 4, position: Position(row: 2, col: 0)), Tile(value: 4, position: Position(row: 2, col: 1)), Tile(value: 4, position: Position(row: 2, col: 2)), Tile(value: 4, position: Position(row: 2, col: 3))],
                [Tile(value: 0, position: Position(row: 3, col: 0)), Tile(value: 0, position: Position(row: 3, col: 1)), Tile(value: 0, position: Position(row: 3, col: 2)), Tile(value: 2, position: Position(row: 3, col: 3))]
            ]
            
          //  let (moved, score) = viewModel.slide(.right)
            let (moved, score) = game.slide(.right)
            
            XCTAssertTrue(moved)
            XCTAssertEqual(score, 32)
            XCTAssertEqual(game.tiles[0][0].value, 0)
            XCTAssertEqual(game.tiles[0][1].value, 0)
            XCTAssertEqual(game.tiles[0][2].value, 4)
            XCTAssertEqual(game.tiles[0][3].value, 8)
            XCTAssertEqual(game.tiles[1][0].value, 0)
            XCTAssertEqual(game.tiles[1][1].value, 0)
            XCTAssertEqual(game.tiles[1][2].value, 0)
            XCTAssertEqual(game.tiles[1][3].value, 4)
            XCTAssertEqual(game.tiles[2][0].value, 0)
            XCTAssertEqual(game.tiles[2][1].value, 0)
            XCTAssertEqual(game.tiles[2][2].value, 8)
            XCTAssertEqual(game.tiles[2][3].value, 8)
            XCTAssertEqual(game.tiles[3][0].value, 0)
            XCTAssertEqual(game.tiles[3][1].value, 0)
            XCTAssertEqual(game.tiles[3][2].value, 0)
            XCTAssertEqual(game.tiles[3][3].value, 2)
        }
        
        func testSlideUp() {
            game.tiles /*viewModel.tiles */= [
                [Tile(value: 2, position: Position(row: 0, col: 0)), Tile(value: 2, position: Position(row: 0, col: 1)), Tile(value: 0, position: Position(row: 0, col: 2)), Tile(value: 4, position: Position(row: 0, col: 3))],
                [Tile(value: 4, position: Position(row: 1, col: 0)), Tile(value: 4, position: Position(row: 1, col: 1)), Tile(value: 2, position: Position(row: 1, col: 2)), Tile(value: 2, position: Position(row: 1, col: 3))],
                [Tile(value: 2, position: Position(row: 2, col: 0)), Tile(value: 2, position: Position(row: 2, col: 1)), Tile(value: 4, position: Position(row: 2, col: 2)), Tile(value: 4, position: Position(row: 2, col: 3))],
                [Tile(value: 4, position: Position(row: 3, col: 0)), Tile(value: 0, position: Position(row: 3, col: 1)), Tile(value: 4, position: Position(row: 3, col: 2)), Tile(value: 0, position: Position(row: 3, col: 3))]
            ]
            
           // let (moved, score) = viewModel.slide(.up)
            let (moved, score) = game.slide(.up)
            
            XCTAssertTrue(moved)
            XCTAssertEqual(score, 8)
            XCTAssertEqual(game.tiles[0][0].value, 2)
            XCTAssertEqual(game.tiles[0][1].value, 2)
            XCTAssertEqual(game.tiles[0][2].value, 2)
            XCTAssertEqual(game.tiles[0][3].value, 4)
            XCTAssertEqual(game.tiles[1][0].value, 4)
            XCTAssertEqual(game.tiles[1][1].value, 4)
            XCTAssertEqual(game.tiles[1][2].value, 8)
            XCTAssertEqual(game.tiles[1][3].value, 2)
            XCTAssertEqual(game.tiles[2][0].value, 2)
            XCTAssertEqual(game.tiles[2][1].value, 2)
            XCTAssertEqual(game.tiles[2][2].value, 0)
            XCTAssertEqual(game.tiles[2][3].value, 4)
            XCTAssertEqual(game.tiles[3][0].value, 4)
            XCTAssertEqual(game.tiles[3][1].value, 0)
            XCTAssertEqual(game.tiles[3][2].value, 0)
            XCTAssertEqual(game.tiles[3][3].value, 0)
        }
        
        func testSlideDown() {
            game.tiles /*viewModel.tiles*/ = [
                [Tile(value: 2, position: Position(row: 0, col: 0)), Tile(value: 2, position: Position(row: 0, col: 1)), Tile(value: 0, position: Position(row: 0, col: 2)), Tile(value: 4, position: Position(row: 0, col: 3))],
                [Tile(value: 4, position: Position(row: 1, col: 0)), Tile(value: 4, position: Position(row: 1, col: 1)), Tile(value: 2, position: Position(row: 1, col: 2)), Tile(value: 2, position: Position(row: 1, col: 3))],
                [Tile(value: 2, position: Position(row: 2, col: 0)), Tile(value: 2, position: Position(row: 2, col: 1)), Tile(value: 4, position: Position(row: 2, col: 2)), Tile(value: 4, position: Position(row: 2, col: 3))],
                [Tile(value: 4, position: Position(row: 3, col: 0)), Tile(value: 0, position: Position(row: 3, col: 1)), Tile(value: 4, position: Position(row: 3, col: 2)), Tile(value: 0, position: Position(row: 3, col: 3))]
            ]
            
           // let (moved, score) = viewModel.slide(.down)
            let (moved, score) = game.slide(.down)
            
            XCTAssertTrue(moved)
            XCTAssertEqual(score, 8)
            XCTAssertEqual(game.tiles[3][0].value, 4)
            XCTAssertEqual(game.tiles[3][1].value, 2)
            XCTAssertEqual(game.tiles[3][2].value, 8)
            XCTAssertEqual(game.tiles[3][3].value, 4)
            XCTAssertEqual(game.tiles[2][0].value, 2)
            XCTAssertEqual(game.tiles[2][1].value, 4)
            XCTAssertEqual(game.tiles[2][2].value, 2)
            XCTAssertEqual(game.tiles[2][3].value, 2)
            XCTAssertEqual(game.tiles[1][0].value, 4)
            XCTAssertEqual(game.tiles[1][1].value, 2)
            XCTAssertEqual(game.tiles[1][2].value, 0)
            XCTAssertEqual(game.tiles[1][3].value, 4)
            XCTAssertEqual(game.tiles[0][0].value, 2)
            XCTAssertEqual(game.tiles[0][1].value, 0)
            XCTAssertEqual(game.tiles[0][2].value, 0)
            XCTAssertEqual(game.tiles[0][3].value, 0)
        }
    
    func testBestMoveDirection() {
            // Example 1: Test a board where moving right is the best move
            let tiles1: [[Tile]] = [
                [Tile(value: 2, position: Position(row: 0, col: 0)),
                 Tile(value: 2, position: Position(row: 0, col: 1)),
                 Tile(value: 4, position: Position(row: 0, col: 2)),
                 Tile(value: 8, position: Position(row: 0, col: 3))],
                
                [Tile(value: 0, position: Position(row: 1, col: 0)),
                 Tile(value: 4, position: Position(row: 1, col: 1)),
                 Tile(value: 0, position: Position(row: 1, col: 2)),
                 Tile(value: 4, position: Position(row: 1, col: 3))],
                
                [Tile(value: 8, position: Position(row: 2, col: 0)),
                 Tile(value: 8, position: Position(row: 2, col: 1)),
                 Tile(value: 8, position: Position(row: 2, col: 2)),
                 Tile(value: 8, position: Position(row: 2, col: 3))],
                
                [Tile(value: 16, position: Position(row: 3, col: 0)),
                 Tile(value: 0, position: Position(row: 3, col: 1)),
                 Tile(value: 16, position: Position(row: 3, col: 2)),
                 Tile(value: 16, position: Position(row: 3, col: 3))]
            ]
            
         //   var viewModel = GameViewModel()
        game.tiles /* viewModel.tiles */ = tiles1
            
            let bestDirection1 = game/*viewModel*/.bestMoveDirection()
            XCTAssertEqual(bestDirection1, .left, "The best move should be to the right in this case.")
            
            // Example 2: Test a board where moving down is the best move
            let tiles2: [[Tile]] = [
                [Tile(value: 0, position: Position(row: 0, col: 0)), Tile(value: 0, position: Position(row: 0, col: 1)), Tile(value: 4, position: Position(row: 0, col: 2)), Tile(value: 8, position: Position(row: 0, col: 3))],
                [Tile(value: 4, position: Position(row: 1, col: 0)), Tile(value: 4, position: Position(row: 1, col: 1)), Tile(value: 0, position: Position(row: 1, col: 2)), Tile(value: 0, position: Position(row: 1, col: 3))],
                [Tile(value: 2, position: Position(row: 2, col: 0)), Tile(value: 2, position: Position(row: 2, col: 1)), Tile(value: 4, position: Position(row: 2, col: 2)), Tile(value: 8, position: Position(row: 2, col: 3))],
                [Tile(value: 0, position: Position(row: 3, col: 0)), Tile(value: 4, position: Position(row: 3, col: 1)), Tile(value: 0, position: Position(row: 3, col: 2)), Tile(value: 4, position: Position(row: 3, col: 3))]
            ]
            
            game/*viewModel*/.tiles = tiles2
            
            let bestDirection2 = game/*viewModel*/.bestMoveDirection()
            XCTAssertEqual(bestDirection2, .left, "The best move should be down in this case.")
            
            // Example 3: Test a board where moving right is the best move
            let tiles3: [[Tile]] = [
                [Tile(value: 4, position: Position(row: 0, col: 0)), Tile(value: 2, position: Position(row: 0, col: 1)), Tile(value: 2, position: Position(row: 0, col: 2)), Tile(value: 0, position: Position(row: 0, col: 3))],
                [Tile(value: 2, position: Position(row: 1, col: 0)), Tile(value: 2, position: Position(row: 1, col: 1)), Tile(value: 0, position: Position(row: 1, col: 2)), Tile(value: 0, position: Position(row: 1, col: 3))],
                [Tile(value: 2, position: Position(row: 2, col: 0)), Tile(value: 0, position: Position(row: 2, col: 1)), Tile(value: 0, position: Position(row: 2, col: 2)), Tile(value: 0, position: Position(row: 2, col: 3))],
                [Tile(value: 4, position: Position(row: 3, col: 0)), Tile(value: 4, position: Position(row: 3, col: 1)), Tile(value: 4, position: Position(row: 3, col: 2)), Tile(value: 4, position: Position(row: 3, col: 3))]
            ]
            
            game/*viewModel*/.tiles = tiles3
            
            let bestDirection3 = game/*viewModel*/.bestMoveDirection()
            XCTAssertEqual(bestDirection3, .left, "The best move should be to the right in this case.")
        
        // Example 4: Test a board where moving down is the best move
        let tiles4: [[Tile]] = [
            [Tile(value: 64, position: Position(row: 0, col: 0)), Tile(value: 128, position: Position(row: 0, col: 1)), Tile(value: 64, position: Position(row: 0, col: 2)), Tile(value: 32, position: Position(row: 0, col: 3))],
            [Tile(value: 32, position: Position(row: 1, col: 0)), Tile(value: 64, position: Position(row: 1, col: 1)), Tile(value: 32, position: Position(row: 1, col: 2)), Tile(value: 8, position: Position(row: 1, col: 3))],
            [Tile(value: 16, position: Position(row: 2, col: 0)), Tile(value: 8, position: Position(row: 2, col: 1)), Tile(value: 4, position: Position(row: 2, col: 2)), Tile(value: 2, position: Position(row: 2, col: 3))],
            [Tile(value: 0, position: Position(row: 3, col: 0)), Tile(value: 0, position: Position(row: 3, col: 1)), Tile(value: 0, position: Position(row: 3, col: 2)), Tile(value: 0, position: Position(row: 3, col: 3))]
        ]
        
        game.tiles = tiles4
        
        let bestDirection4 = game/*viewModel*/.bestMoveDirection1()
        XCTAssertEqual(bestDirection4, .down, "The best move should be to the right in this case.")
        }

    // Test case for strictly increasing row monotonicity
        func testIncreasingRowMonotonicity() {
            let grid = [
                [2, 4, 8, 16],
                [8, 16, 0, 32],
                [32, 16, 64, 8],
                [8, 16, 32, 64]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, -9.0, "Monotonicity score for increasing row is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, -9.0, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, -9.0, "Monotonicity score for increasing row is incorrect.")
        }
    
    // Test case for monotonicity in rows
        func testColumnMonotonicity1() {
            let grid = [
                [2, 4, 8, 16],
                [4, 8, 16, 32],
                [2, 0, 2, 0],
                [0, 4, 8, 16]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, -7.0, "Monotonicity score for increasing column is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, -6.0, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, -6.0, "Monotonicity score for increasing row is incorrect.")
        }
    
    // Test case for strictly decreasing row monotonicity
        func testDecreasingRowMonotonicity() {
            let grid = [
                [16, 8, 4, 2],
                [4, 0, 2, 0],
                [8, 4, 0, 0],
                [32, 4, 8, 16]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, -6, "Monotonicity score for decreasing row is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, -6, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, -6, "Monotonicity score for increasing row is incorrect.")
        }
    
    // Test case for mixed values row
        func testMixedRowMonotonicity() {
            let grid = [
                [2, 16, 4, 8],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, -2.0, "Monotonicity score for mixed row is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, -2.0, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, -2.0, "Monotonicity score for increasing row is incorrect.")
        }
    
    // Test case for monotonicity in columns
        func testColumnMonotonicity() {
            let grid = [
                [2, 8, 0, 0],
                [4, 16, 0, 0],
                [0, 0, 0, 0],
                [16, 32, 0, 0]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, -5.0, "Monotonicity score for increasing column is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, 0.0, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, 0.0, "Monotonicity score for increasing row is incorrect.")
        }
    
    // Test case for penalty when zeros are present
       func testZerosPenaltyMonotonicity() {
           let grid = [
               [2, 0, 8, 16],
               [4, 0, 0, 0],
               [0, 0, 0, 4],
               [0, 0, 0, 0]
           ]
           let result = aiGame.monotonicity(grid)
           XCTAssertEqual(result, -3.0, "Monotonicity score should penalize zeros.")
           let result2 = aiGame.monotonicity2(grid)
           XCTAssertEqual(result2, -1.0, "Monotonicity score for increasing row is incorrect.")
           let result1 = aiGame.monotonicity1(grid)
           XCTAssertEqual(result1, -1.0, "Monotonicity score for increasing row is incorrect.")
       }
    
    // Test case for empty grid
        func testEmptyGridMonotonicity() {
            let grid = [
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]
            ]
            let result = aiGame.monotonicity(grid)
            XCTAssertEqual(result, 0.0, "Monotonicity score for empty grid is incorrect.")
            let result2 = aiGame.monotonicity2(grid)
            XCTAssertEqual(result2, 0.0, "Monotonicity score for increasing row is incorrect.")
            let result1 = aiGame.monotonicity1(grid)
            XCTAssertEqual(result1, 0.0, "Monotonicity score for increasing row is incorrect.")
        }

}
