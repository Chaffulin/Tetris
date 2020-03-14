//
//  Shape.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/10.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import UIKit
import SpriteKit


//MARK: - Orientation
let NumOfOrientations: UInt32 = 4
var currentOrientation = Orientation.Up

enum Orientation: Int, CustomStringConvertible {
    case Up = 0, Right, Down, Left
    
        var orientation: String {
            switch self {
            case .Up:
                return "0"
            case .Right:
                return "90"
            case .Down:
                return "180"
            case .Left:
                return "270"
            }
        }
    
    var description: String {
        return self.orientation
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.Left.rawValue {
            rotated = Orientation.Up.rawValue
        } else if rotated < 0 {
            rotated = Orientation.Left.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
    
    static func randomOrientation() -> Orientation {
        if let orientation = Orientation(rawValue: Int(arc4random_uniform(NumOfOrientations))) {
            return orientation
        }
        return Orientation.Up
    }
}


//MARK: - Shape
let NumOfShapeTypes: UInt32 = 7

enum ShapeType: Int, CustomStringConvertible {
    case Squere = 0, L, J, Line, Z, S, T
    
    public var shapeName: String {
        switch self {
        case .Squere:
            return "Square"
        case .L:
            return "LShape"
        case .J:
            return "JShape"
        case .Line:
            return "Line"
        case .Z:
            return "ZShape"
        case .S:
            return "SShape"
        case .T:
            return "TShape"
        }
    }
    
    var description: String {
        return self.shapeName
    }
}


class Shape: Hashable {
    
    var color: BlockColor
    var blocks = Array<Block>()
    var orientation: Orientation
    var column: Int
    var row: Int
    var newShapeOrientation: Orientation
    var shapeType: ShapeType
    
    init(row: Int, column: Int, color: BlockColor, orientation: Orientation, shapeType: ShapeType) {
        self.newShapeOrientation = orientation
        self.column = column
        self.row = row
        self.color = color
        self.orientation = orientation
        self.shapeType = shapeType
    }
    
    convenience init(row: Int, column: Int, shapeType: ShapeType) {
        
        self.init(row: row, column: column, color: BlockColor.randomColor(), orientation: Orientation.randomOrientation(), shapeType: shapeType)
        
        initializeBlocks()
    }
    
    // MARK - Required override
    var blockDiffPositions: [Orientation: Array<(rowDiff: Int, columnDiff: Int)>] {
        return [:]
    }
    
    var bottomBlocksWithOrientation: [Orientation: Array<Block>] {
        return [:]
    }
    
    var leftBlocksWithOrientation: [Orientation: Array<Block>] {
        return [:]
    }
    
    var rightBlocksWithOrientation: [Orientation: Array<Block>] {
        return [:]
    }
    
    // final means subclass can't override this method
    final func initializeBlocks() {
        guard let blockOfOrientation = blockDiffPositions[orientation] else {
            return
        }
        
        // shape current position
        // (row: 0, column: 4) is the origin
        blocks = blockOfOrientation.map{ (diff) -> Block in
            return Block(row: row + diff.rowDiff, column: column + diff.columnDiff, color: color)
        }
    }
    
    //Block position after rotate
    final func rotateBlocks(orientation: Orientation) {
        guard let blockOfOrientation: Array<(rowDiff: Int, columnDiff: Int)> = blockDiffPositions[orientation] else {
            return
        }
        
        for (idx, diff) in blockOfOrientation.enumerated() {
            blocks[idx].row = row + diff.rowDiff
            blocks[idx].column = column + diff.columnDiff
        }
    }
    
//delete
    final func lowerShapeByOneRow() {
        moveBy(rows: 1, columns: 0)
    }
    
    final func moveBy(rows: Int, columns: Int) {
        self.row += rows
        self.column += columns
        for block in blocks.reversed() {
            block.row += rows
            block.column += columns
        }
    }
    
    //delete
    final func moveTo(row: Int, column: Int) {
        self.row = row
        self.column = column
        rotateBlocks(orientation: orientation)
    }
    
    final class func randomShape(startingRow: Int, startingColumn: Int) -> Shape {
        currentOrientation = Orientation.Up
        if let shape = ShapeType(rawValue: Int(arc4random_uniform(NumOfShapeTypes))) {
            switch shape {
            case ShapeType.Squere:
                return SquareShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.L:
                return LShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.J:
                return JShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.Line:
                return LineShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.Z:
                return ZShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.S:
                return SShape(row: startingRow, column: startingColumn, shapeType: shape)
            case ShapeType.T:
                return TShape(row: startingRow, column: startingColumn, shapeType: shape)
            }
        }
        return SquareShape(row: startingRow, column: startingColumn, shapeType: ShapeType.Squere)
    }
    
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(column)
        hasher.combine(row)
    }
    
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
}
