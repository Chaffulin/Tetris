//
//  SquareShape.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/10.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import UIKit

class SquareShape: Shape {
    
    /*
            |0|1|
            |2|3|
     */
    
    override var blockDiffPositions: [Orientation : Array<(rowDiff: Int, columnDiff: Int)>] {
        return [
            Orientation.Up: [(0,0), (0,1), (1,0),(1,1)],
            Orientation.Right: [(0,0), (0,1), (1,0),(1,1)],
            Orientation.Down: [(0,0), (0,1), (1,0),(1,1)],
            Orientation.Left: [(0,0), (0,1), (1,0),(1,1)]
        ]
    }
    
    override var bottomBlocksWithOrientation: [Orientation : Array<Block>] {
        return [
            Orientation.Up: [blocks[2], blocks[3]],
            Orientation.Right: [blocks[2], blocks[3]],
            Orientation.Down: [blocks[2], blocks[3]],
            Orientation.Left: [blocks[2], blocks[3]]
        ]
    }
    
    override var leftBlocksWithOrientation: [Orientation : Array<Block>] {
        return [
            Orientation.Up: [blocks[0], blocks[2]],
            Orientation.Right: [blocks[0], blocks[2]],
            Orientation.Down: [blocks[0], blocks[2]],
            Orientation.Left: [blocks[0], blocks[2]]
        ]
    }
    
    override var rightBlocksWithOrientation: [Orientation : Array<Block>] {
        return [
            Orientation.Up: [blocks[1], blocks[3]],
            Orientation.Right: [blocks[1], blocks[3]],
            Orientation.Down: [blocks[1], blocks[3]],
            Orientation.Left: [blocks[1], blocks[3]]
        ]
    }
}
