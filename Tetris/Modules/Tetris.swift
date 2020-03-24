//
//  Tetris.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/14.
//  Copyright © 2020 Chaffulin. All rights reserved.
//
import UIKit

let NumRows = 20
let NumColumns = 10
let StartingRow = 0
let StartingColumn = 4
let newShapeRow = 2
var newShapeColumn = 12
var nextShape: Shape?
var currentShape: Shape?
var bottomBlocks: Array<Block>?
var boardArray: Array2D<Block> = Array2D<Block>(rows: NumRows, columns: NumColumns + 5)
var nextShapePositions = Array<BoardPoint>()

class Tetris {
    
    var stopNow: Bool = false
    
    func beginGame() {
        if nextShape == nil {
            nextShape = Shape.randomShape(startingRow: newShapeRow, startingColumn: newShapeColumn)
        }
        newShape()
    }
    
    func newShape() {
        if stopNow {
            stopTimer()
        }
        
        if let next = nextShape {
            
            for point in nextShapePositions {
                boardArray[point.row, point.column] = nil
            }
            nextShapePositions.removeAll()
            
            next.moveTo(row: StartingRow, column: StartingColumn)
            currentShape = next
        }
        
        if let current = currentShape, let bottomArray = current.bottomBlocksWithOrientation[current.newShapeOrientation] {
            bottomBlocks = bottomArray
            for block in bottomArray {
                if (boardArray[block.row + 1, block.column] != nil) && !stopNow {
                    stopNow = true
                }
            }
        }
        
        nextShape = Shape.randomShape(startingRow: newShapeRow, startingColumn: newShapeColumn)
        if let next = nextShape {
            addNextShapeOnBoard(next)
        }
    }
    
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func addNextShapeOnBoard(_ nextShape: Shape) {
        let blocks = nextShape.blocks
        for block in blocks {
            boardArray[block.row, block.column] = block
            let point = BoardPoint(row: block.row, column: block.column)
            nextShapePositions.append(point)
        }
    }
}

