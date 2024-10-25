//
//  GameView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 21.08.2024.
//

import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()
    let tileSize: CGFloat = 80
    let padding: CGFloat = 8
    
    @State var isAIPlaying = false
    @State var selectedAlgorithm = Algorithm.Expectimax

    @State var timer = Timer.publish(every: 0.45, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("2048")
                .font(.largeTitle)
                .padding()
            
            HStack {
                // Score Display
                Text("Score: \(viewModel.score)")
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(viewModel.score)))
                    .transaction { t in
                        t.animation = .default
                    }
                Spacer()
            }
            .font(.title)
            .foregroundColor(.accentColor)
            .padding()
            
            HStack {
                // Algorithm Display
               AlgorithmMenu(algorithm:$selectedAlgorithm)
                .onChange(of: selectedAlgorithm) {
                    viewModel.setAlgorithm(selectedAlgorithm)
                } // onChange
                Spacer()
               
                // AI
                   Button(action: {
                       isAIPlaying.toggle()
                }) {
                    HStack {
                        Image(systemName: isAIPlaying ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 34, height: 34)
                        Text(isAIPlaying ? "AI Stop" : "AI Play")
                    }
                }
            }
            .font(.title)
            .foregroundColor(.accentColor)
            .padding()
            
            // Game Over
            Text(viewModel.isGameOver  ? "Game Over": " ___ ")
                    .font(.title)
                    .foregroundColor(viewModel.isGameOver  ? .red : .clear)
     
            //  Grid
            GridView(tiles: viewModel.tiles, tileSize: tileSize, padding: padding, optimalDirection: viewModel.optimalDirection, isShowingOptimalDirection: viewModel.isShowingOptimalDirection)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                          withAnimation {
                                handleSwipe(value: value)
                          }
                        }
                )
            HStack {
                // Reset Button
                Button(action: {
                    withAnimation {
                        viewModel.resetGame()
                    }
                }) {
                    Text("Restart")
                        .font(.title)
                        .padding()
                }
                
                Spacer()
                
                // Show Optimal
                Button(action: {
                    viewModel.isShowingOptimalDirection.toggle()
                }) {
                    HStack {
                        Image(systemName: viewModel.isShowingOptimalDirection ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 34, height: 34)
                        Text("Hint")
                    }
                }
            }
            .font(.title)
            .foregroundColor(.accentColor)
            .padding()
        }
      .onReceive(timer){ value in
          if isAIPlaying  && !viewModel.isGameOver {
              if selectedAlgorithm == Algorithm.MonteCarloAsync {
                  viewModel.monteCarloAsyncAIMove()
              } else if selectedAlgorithm == Algorithm.Expectimax1 {
                  viewModel.expectimaxAsyncAIMove()
              } else {
                    viewModel.executeAIMove()
              }
            }
        }
      .onChange(of: selectedAlgorithm) { oldValue,newValue in
                  // Recreate the timer with the new interval
          if newValue == Algorithm.MonteCarlo {
              timer = Timer.publish(every: 0.65, on: .main, in: .common).autoconnect()
          } else {
              timer = Timer.publish(every: 0.45, on: .main, in: .common).autoconnect()
          }
        }
    }
    
    // Handle swipe gesture and trigger game actions
    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 20
        let horizontalShift = value.translation.width
        let verticalShift = value.translation.height
        
            if abs(horizontalShift) > abs(verticalShift) {
                if horizontalShift > threshold {
                    viewModel.move(.right)
                } else if horizontalShift < -threshold {
                    viewModel.move(.left)
                }
            } else {
                if verticalShift > threshold {
                    viewModel.move(.down)
                } else if verticalShift < -threshold {
                    viewModel.move(.up)
                }
           }
    }
}

#Preview {
    GameView() //.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
