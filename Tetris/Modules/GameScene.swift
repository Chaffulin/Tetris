//
//  GameScene.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/11.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import SpriteKit

let BlockSize: CGFloat = 25.0
let TimeInterval: TimeInterval = 0.5
var timer = Timer()

class GameScene: SKScene {
    
    // Gameboard Layout
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    var layerPosition = CGPoint(x: 6, y: -safeAreaTop)
    // Is the current shape arrived the bottom of the gameboard?
    var isArriveBottom = false
    let tetris = Tetris()
    var blockNodes = Array<SKNode>()
    //last interval position of the falling shape
    var lastShapePosition = Array<BoardPoint>()
    var isRowFull = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // (0, 0) in spriteKit is the bottom-left corner.
        // We will draw Swiftris from the top-left corner (0, 1.0).
        anchorPoint = CGPoint(x: 0, y: 1.0)
        let background = SKSpriteNode(imageNamed: "background")
        background.alpha = 0.7
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        background.size = self.size
        addChild(background)
        
        addChild(gameLayer)
        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
        let gameBoardsize = CGSize(width: BlockSize * CGFloat(NumColumns), height: BlockSize * CGFloat(NumRows))
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: gameBoardsize)
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameBoard.position = layerPosition
        
        shapeLayer.position = layerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
        tetris.beginGame()
        startTimer()
        playThemeSound()
    }
    
    func blockCenterPoint(row: Int, column: Int) -> CGPoint {
        let x = layerPosition.x + CGFloat(column) * BlockSize + BlockSize / 2
        let y = layerPosition.y - CGFloat(row) * BlockSize - BlockSize / 2
        return CGPoint(x: x, y: y)
    }

    func startTimer() {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(reloadFallingShape), userInfo: nil, repeats: true)
    }
    
    @objc func reloadFallingShape() {
        
        if !isArriveBottom {
            if let currentShape = currentShape {
                
                // Delete the shape at last interval position
                
                // Add current shape on gameBoard
                for block in currentShape.blocks {
                    boardArray[block.row, block.column] = block
                    let boardPoint = BoardPoint(row: block.row, column: block.column)
                    lastShapePosition.append(boardPoint)
                }
                
                // Stop falling of current shape, if the shape touch the bottom of the gameboard or other shape
                
                drawBoard()
                
                if isCurrentShapeShouldStop() {
                    tetris.newShape()
                    lastShapePosition.removeAll()
                    isArriveBottom = true
                }else {
                    // falling down the current shape to next row
                    currentShape.moveBy(rows: 1, columns: 0)
                }
                
                if lastShapePosition.count > 0 {
                    for lastPosition in lastShapePosition {
                        boardArray[lastPosition.row, lastPosition.column] = nil
                    }
                    lastShapePosition.removeAll()
                }
            }
        }else {
            if isRowFull {
                playBombSound()
                isRowFull = false
            }else {
                playDropSound()
                }
            isArriveBottom = false
        }
    }

    
    func drawBoard() {
        shapeLayer.removeChildren(in: blockNodes)
        blockNodes.removeAll()
        for row in 0...(NumRows - 1) {
            var unNullColumn = 0
            
            for column in 0...(NumColumns + 4) {
                if let block = boardArray[row, column] {
                    let blockNode = SKNode()
                    let blockTexture = SKTexture(imageNamed: block.color.colorName)
                    let blockSize = CGSize(width: BlockSize, height: BlockSize)
                    let blockSpriteNode = SKSpriteNode(texture: blockTexture, size: blockSize)
                    blockSpriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    blockSpriteNode.position = blockCenterPoint(row: block.row, column: block.column)
                    blockNode.addChild(blockSpriteNode)
                    blockNodes.append(blockNode)
                    shapeLayer.addChild(blockNode)
                    unNullColumn += 1
                }
            }
            removeTheFullRow(unNilColumnCount: unNullColumn, currentRow: row)            
        }
    }
    
    //approach bottom line or other static shape should stop
    func isCurrentShapeShouldStop() -> Bool {
        if let bottomBlocks = bottomBlocks {
            for block in bottomBlocks {
                // add all bottom blocks to bottomBlocks
                if block.row == (NumRows - 1) || boardArray[block.row + 1, block.column] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    //remove a whole row when it's full
    func removeTheFullRow(unNilColumnCount unNullColumn: Int, currentRow row: Int) {
        if unNullColumn == NumColumns {
            isRowFull = true
            for column in 0...(NumColumns - 1) {
                boardArray[row, column] = nil
            }
            for r in (0...row - 1).reversed() {
                for c in 0...(NumColumns - 1) {
                    if r == 0 {
                        boardArray[r, c] = nil
                    } else {
                        if let block = boardArray[r, c] {
                            block.row += 1
                            boardArray[r + 1, c] = block
                        } else {
                            boardArray[r + 1, c] = nil
                        }
                    }
                }
            }
        }
    }
    
    func playThemeSound() {
        run(SKAction.repeatForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)))
    }
    
    func playBombSound() {
        run(SKAction.playSoundFileNamed("bomb.mp3", waitForCompletion: true))
    }
    
    func playDropSound() {
        run(SKAction.playSoundFileNamed("drop.mp3", waitForCompletion: true))
    }
}
