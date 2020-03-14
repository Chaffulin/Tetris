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
var nextShape: Shape?
var currentShape: Shape?
var bottomBlocks: Array<Block>?
var boardArray: Array2D<Block> = Array2D<Block>(rows: NumRows, columns: NumColumns)

class Tetris {
    
    let StartingRow = 0
    let StartingColumn = 4
    
    var stopNow: Bool = false
    
    func beginGame() {
        if nextShape == nil {
            nextShape = Shape.randomShape(startingRow: StartingRow, startingColumn: StartingColumn)
        }
        newShape()
    }
    
    func newShape() {
        if stopNow {
            stopTimer()
        }
        currentShape = nextShape
        if let next = nextShape, let bottomArray = next.bottomBlocksWithOrientation[next.newShapeOrientation] {
            for block in bottomArray {
                if (boardArray[block.row + 1, block.column] != nil), !stopNow {
                    stopNow = true
                }
            }
        }
        
        if let shape = currentShape, let blocks = shape.bottomBlocksWithOrientation[shape.newShapeOrientation] {
            bottomBlocks = blocks
        }
        nextShape = Shape.randomShape(startingRow: StartingRow, startingColumn: StartingColumn)
    }
    
    
    func stopTimer() {
        timer.invalidate()
    }
    
}

