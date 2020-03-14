//
//  GameScene.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/11.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import SpriteKit

let BlockSize: CGFloat = 30.0
let TimeInterval: TimeInterval = 0.5
var timer = Timer()

class GameScene: SKScene {
    
    // Gameboard Layout
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    var layerPosition = CGPoint(x: 6, y: -25)
    // Is the current shape arrived the bottom of the gameboard?
    var isArriveBottom = false
    let tetris = Tetris()
    var blockNodes = Array<SKNode>()
    //last interval position of the falling shape
    var lastShapePosition = Array<BoardPoint>()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // (0, 0) in spriteKit is the bottom-left corner.
        // We will draw Swiftris from the top-left corner (0, 1.0).
        anchorPoint = CGPoint(x: 0, y: 1.0)
        let background = SKSpriteNode(imageNamed: "background")
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
        isArriveBottom = false
        
        if let currentShape = currentShape {
            
            // Delete the shape at last interval position
            if lastShapePosition.count > 0 {
                for lastPosition in lastShapePosition {
                    tetris.boardArray[lastPosition.row, lastPosition.column] = nil
                }
                lastShapePosition.removeAll()
            }
            
            // Add current shape on gameBoard
            for block in currentShape.blocks {
                tetris.boardArray[block.row, block.column] = block
                let boardPoint = BoardPoint(row: block.row, column: block.column)
                lastShapePosition.append(boardPoint)
            }
            
            // Stop falling of current shape, if the shape touch the bottom of the gameboard or other shape
            if isCurrentShapeShouldStop() {
                tetris.newShape()
                
                //Stop create new shape
                
                
                lastShapePosition.removeAll()
                isArriveBottom = true
            }
            
            drawBoard()
            
            // falling down the current shape to next row
            if !isArriveBottom {
                currentShape.moveBy(rows: 1, columns: 0)
            }
        }
    }

    
    func drawBoard() {
        shapeLayer.removeChildren(in: blockNodes)
        blockNodes.removeAll()
        print("<<<<<<")
        for row in 0...(NumRows - 1) {
            var unNullColumn = 0
            
                for column in 0...(NumColumns - 1) {
                    if let block = tetris.boardArray[row, column] {
                        print(block)
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
        print("<<<<<<")
    }
    
    //approach bottom line or other static shape should stop
    func isCurrentShapeShouldStop() -> Bool {
        if let bottomBlocks = bottomBlocks {
            for block in bottomBlocks {
                // add all bottom blocks to bottomBlocks
                if block.row == (NumRows - 1) || tetris.boardArray[block.row + 1, block.column] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    //remove a whole row when it's full
    func removeTheFullRow(unNilColumnCount unNullColumn: Int, currentRow row: Int) {
        if unNullColumn == NumColumns {
            for column in 0...(NumColumns - 1) {
                tetris.boardArray[row, column] = nil
            }
            for r in (0...row - 1).reversed() {
                for c in 0...(NumColumns - 1) {
                    if r == 0 {
                        tetris.boardArray[r, c] = nil
                    } else {
                        if let block = tetris.boardArray[r, c] {
                            block.row += 1
                            tetris.boardArray[r + 1, c] = block
                        } else {
                            tetris.boardArray[r + 1, c] = nil
                        }
                    }
                }
            }
        }
    }
}
