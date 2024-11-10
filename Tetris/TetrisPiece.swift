//
//  TetrisPiece.swift
//  Tetris
//
//  Created by Morteza on 11/10/24.
//


import UIKit

struct TetrisPiece {
    var shape: TetrisShape
    var color: UIColor
    var position: (row: Int, col: Int)
    
    // Initialize with random shape and color
    init(shape: TetrisShape, color: UIColor, position: (row: Int, col: Int)) {
        self.shape = shape
        self.color = color
        self.position = position
    }
    
    // Generate a random piece
    static func randomPiece(columns: Int) -> TetrisPiece {
        let shapes: [TetrisShape] = [.I, .O, .T, .S, .Z, .J, .L]
        let colors: [UIColor] = [.cyan, .yellow, .purple, .green, .red, .blue, .orange]
        
        let randomIndex = Int.random(in: 0...shapes.count - 1)
        let shape = shapes[randomIndex]
        let color = colors[randomIndex]
        
        // Start position (top center of the board)
        let startRow = 0
        let startCol = (columns - shape.blocks[0].count) / 2
        
        return TetrisPiece(shape: shape, color: color, position: (startRow, startCol))
    }
}
