//
//  TetrisShape.swift
//  Tetris
//
//  Created by Morteza on 11/10/24.
//


struct TetrisShape {
    let blocks: [[Bool]]
    
    // Rotate the shape clockwise
    func rotated() -> TetrisShape {
        let newBlocks = (0..<blocks.count).map { row in
            (0..<blocks[row].count).map { col in
                blocks[blocks.count - col - 1][row]
            }
        }
        return TetrisShape(blocks: newBlocks)
    }
    
    // Define all Tetris shapes (I, O, T, S, Z, J, L)
    static let I = TetrisShape(blocks: [
        [false, true, false, false],
        [false, true, false, false],
        [false, true, false, false],
        [false, true, false, false]
    ])
    
    static let O = TetrisShape(blocks: [
        [true, true],
        [true, true]
    ])
    
    static let T = TetrisShape(blocks: [
        [false, true, false],
        [true, true, true],
        [false, false, false]
    ])
    
    static let S = TetrisShape(blocks: [
        [false, true, true],
        [true, true, false],
        [false, false, false]
    ])
    
    static let Z = TetrisShape(blocks: [
        [true, true, false],
        [false, true, true],
        [false, false, false]
    ])
    
    static let J = TetrisShape(blocks: [
        [true, false, false],
        [true, true, true],
        [false, false, false]
    ])
    
    static let L = TetrisShape(blocks: [
        [false, false, true],
        [true, true, true],
        [false, false, false]
    ])
}
