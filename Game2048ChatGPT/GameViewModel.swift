//
//  GameViewModel.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 21.08.2024.
//

import SwiftUI

@Observable
class GameViewModel /*: ObservableObject */ {
   /*@Published */private var game: Game
    var isShowingOptimalDirection = false
    
    init() {
        self.game = Game()
    }
    
    var tiles: [[Tile]] {
        game.tiles
    }
    
    var score: Int {
        game.score
    }
    var isGameOver: Bool {
        game.isGameOver
    }
   
    var optimalDirection: Direction {
        if  isShowingOptimalDirection  {
            game.bestMoveDirection()
        } else {
            Direction.up
        }
    }
  
    // MARK: Intents
    
    func resetGame() {
        game.resetGame()
    }
    
    func move(_ direction: Direction) {
        game.move(direction)
    }
    
    func executeAIMove() {
        game.executeAIMove()
    }
    
    func monteCarloAsyncAIMove() {
        Task{
            let bestDirection =  await game.bestMoveDirectionMonteCarloAsync()
                game.move(bestDirection)
        }
    }
    
    func expectimaxAsyncAIMove() {
        Task{
            let bestDirection =  await game.bestMoveDirectionExpectimaxAsync()
                game.move(bestDirection)
        }
    }
    
    func setAlgorithm (_ algorithm:Algorithm){
        game.algorithm = algorithm
    }
    // Other methods that interact with `Game` struct
}
