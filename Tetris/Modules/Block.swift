//
//  Block.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/11.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, CustomStringConvertible {
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    var colorName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case.Yellow:
            return "yellow"
        }
    }
    var description: String {
        return self.colorName
    }
    
    static func randomColor() -> BlockColor {
        if let blockColor = BlockColor(rawValue: Int(arc4random_uniform(NumberOfColors))) {
            return blockColor
        }
        return BlockColor.Blue
    }
}

/*
 Hashable allows us to store Block in Array2D
*/

class Block: Hashable, CustomStringConvertible {
    
    // represent the location of the Block on our game board
    var row: Int
    var column: Int
    // represent the visual element of the Block
    var sprite: SKSpriteNode?
    let color: BlockColor

    var description: String {
        return "\(color): [\(row), \(column)]"
    }
    var spriteName: String {
        return color.colorName
    }
    func hash(into: Int) {
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    
    init(row: Int, column: Int, color: BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
    
    static func == (lhs: Block, rhs: Block) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color == rhs.color
    }
    
    
}
