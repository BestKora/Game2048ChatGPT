//
//  OptimalDirectionView.swift
//  My2048New
//
//  Created by Tatiana Kornilova on 06.01.2023.
//

import SwiftUI

struct OptimalDirectionView: View {
    var direction: Direction
    
    var body: some View {
        GeometryReader { geometry in
            let squareSide = min(geometry.size.width, geometry.size.height)
            ZStack {
                switch direction {
                case .up:
                    Image(systemName: "chevron.up")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .position(x: squareSide / 2,y: 10)
                        .zIndex(1000)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 3, height: squareSide / 2)
                        .position(x: squareSide / 2,y: squareSide / 4)
                case .down:
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .position(x: squareSide / 2,y: squareSide - 10 )
                        .zIndex(1000)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 3, height: squareSide / 2)
                        .position(x: squareSide / 2,y: squareSide * 3 / 4)
                case .left:
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .position(x: 10 ,y: squareSide / 2)
                        .zIndex(1000)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: squareSide / 2, height: 3)
                        .position(x: squareSide / 4,y: squareSide / 2)
                case .right:
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .position(x: squareSide - 10,y: squareSide / 2)
                        .zIndex(1000)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: squareSide / 2, height: 3)
                        .position(x: squareSide  * 3 / 4,y: squareSide / 2)
                }
            } // ZStack
            .foregroundColor(.red)
        } // Geometry
    } //body
}


struct OptimalDirectionArrow: View {
    var direction: Direction
    
    var body: some View {
        GeometryReader { geometry in
            let arrowLength = min(geometry.size.width, geometry.size.height) / 2
            
            Path { path in
                switch direction {
                case .up:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 - arrowLength))
                case .down:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 + arrowLength))
                case .left:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2 - arrowLength, y: geometry.size.height / 2))
                case .right:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2 + arrowLength, y: geometry.size.height / 2))
               
                }
            }
            .stroke(Color.red, lineWidth: 4)
            .overlay(
                ArrowheadShape(direction: direction)
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                        .rotationEffect( rotationAngle(for: direction))
                        .position(arrowheadPosition(in: geometry.size, direction: direction, length: arrowLength))
                        .transaction { transaction in
                            transaction.animation = nil
                        }
            )
        }
    }
    
    func arrowheadPosition(in size: CGSize, direction: Direction, length: CGFloat) -> CGPoint {
        switch direction {
        case .up:
            return CGPoint(x: size.width / 2, y: size.height / 2 - length)
        case .down:
            return CGPoint(x: size.width / 2, y: size.height / 2 + length)
        case .left:
            return CGPoint(x: size.width / 2 - length, y: size.height / 2)
        case .right:
            return CGPoint(x: size.width / 2 + length, y: size.height / 2)
        }
    }
    
    func rotationAngle(for direction: Direction) -> Angle {
           switch direction {
           case .up:
               return Angle.degrees(0)
           case .down:
               return Angle.degrees(180)
           case .left:
               return Angle.degrees(-90)
           case .right:
               return Angle.degrees(90)
           }
       }
}

struct ArrowheadShape: Shape {
    var direction: Direction
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tip = CGPoint(x: rect.midX, y: rect.minY)
        let left = CGPoint(x: rect.minX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: tip)
        path.addLine(to: left)
        path.addLine(to: right)
        path.closeSubpath()
            
        return path
    }
}

#Preview {
      // OptimalDirectionView(direction: .right)
      OptimalDirectionArrow(direction: .right)
        .padding()
    }

