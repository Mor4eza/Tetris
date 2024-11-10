//
//  ViewController.swift
//  Tetris
//
//  Created by Morteza on 4/25/23.
//


import UIKit

class ViewController: UIViewController {
    private var gameTimer: Timer?
    private let rows = 20
    private let columns = 10
    private var board: [[UIColor?]] = []
    private var currentPiece: TetrisPiece?
    private var score = 0
    private let blockSize: CGFloat = 30.0
    private let scoreLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startGame()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        updateScore()
    }
    
    private func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    // MARK: - Game Logic
    private func startGame() {
        initializeBoard()
        spawnNewPiece()
        score = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(gameTick), userInfo: nil, repeats: true)
    }
    
    private func initializeBoard() {
        board = Array(repeating: Array(repeating: nil, count: columns), count: rows)
    }
    
    @objc private func gameTick() {
        if !movePieceDown() {
            fixPieceInPlace()
            clearFullLines()
            spawnNewPiece()
            if !isPositionValid(currentPiece!.shape, position: currentPiece!.position) {
                endGame()
            }
        }
        drawBoard()
    }
    
    private func spawnNewPiece() {
        currentPiece = TetrisPiece.randomPiece(columns: columns)
    }
    
    private func movePieceDown() -> Bool {
        guard let piece = currentPiece else { return false }
        let newPosition = (piece.position.row + 1, piece.position.col)
        if isPositionValid(piece.shape, position: newPosition) {
            currentPiece?.position = newPosition
            return true
        }
        return false
    }
    
    private func movePieceLeft() {
        guard let piece = currentPiece else { return }
        let newPosition = (piece.position.row, piece.position.col - 1)
        if isPositionValid(piece.shape, position: newPosition) {
            currentPiece?.position = newPosition
            drawBoard()
        }
    }
    
    private func movePieceRight() {
        guard let piece = currentPiece else { return }
        let newPosition = (piece.position.row, piece.position.col + 1)
        if isPositionValid(piece.shape, position: newPosition) {
            currentPiece?.position = newPosition
            drawBoard()
        }
    }
    
    private func rotatePiece() {
        guard let piece = currentPiece else { return }
        let newShape = piece.shape.rotated()
        if isPositionValid(newShape, position: piece.position) {
            currentPiece?.shape = newShape
            drawBoard()
        }
    }
    
    private func fixPieceInPlace() {
        guard let piece = currentPiece else { return }
        for (rowOffset, row) in piece.shape.blocks.enumerated() {
            for (colOffset, block) in row.enumerated() {
                if block {
                    let boardRow = piece.position.row + rowOffset
                    let boardCol = piece.position.col + colOffset
                    board[boardRow][boardCol] = piece.color
                }
            }
        }
        currentPiece = nil
    }
    
    private func clearFullLines() {
        board = board.filter { !$0.allSatisfy { $0 != nil } }
        let clearedLines = rows - board.count
        if clearedLines > 0 {
            score += clearedLines * 100
            updateScore()
            board.insert(contentsOf: Array(repeating: Array(repeating: nil, count: columns), count: clearedLines), at: 0)
        }
    }
    
    private func isPositionValid(_ shape: TetrisShape, position: (row: Int, col: Int)) -> Bool {
        for (rowOffset, row) in shape.blocks.enumerated() {
            for (colOffset, block) in row.enumerated() {
                if block {
                    let boardRow = position.row + rowOffset
                    let boardCol = position.col + colOffset
                    if boardRow < 0 || boardRow >= rows || boardCol < 0 || boardCol >= columns || board[boardRow][boardCol] != nil {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func drawBoard() {
        view.subviews.filter { $0 is BlockView }.forEach { $0.removeFromSuperview() }
        
        for (row, line) in board.enumerated() {
            for (col, color) in line.enumerated() {
                if let color = color {
                    let blockView = BlockView(color: color)
                    blockView.frame = CGRect(x: CGFloat(col) * blockSize, y: CGFloat(row) * blockSize + 100, width: blockSize, height: blockSize)
                    view.addSubview(blockView)
                }
            }
        }
        
        if let piece = currentPiece {
            for (rowOffset, row) in piece.shape.blocks.enumerated() {
                for (colOffset, block) in row.enumerated() {
                    if block {
                        let blockView = BlockView(color: piece.color)
                        blockView.frame = CGRect(x: CGFloat(piece.position.col + colOffset) * blockSize, y: CGFloat(piece.position.row + rowOffset) * blockSize + 100, width: blockSize, height: blockSize)
                        view.addSubview(blockView)
                    }
                }
            }
        }
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        let alert = UIAlertController(title: "Game Over", message: "Your score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in self.startGame() })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            if location.x < view.bounds.midX {
                movePieceLeft()
            } else {
                movePieceRight()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rotatePiece()
        }
    }
}

// MARK: - Supporting Classes
class BlockView: UIView {
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
