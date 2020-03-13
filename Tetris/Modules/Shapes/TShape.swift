//
//  TShape.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/10.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import UIKit

class TShape: Shape {
    /*
      Orientation.Up      |1|2|3|
                            |4|
     
     Orientation.Right      |1|
                          |2|3|
                            |4|
     
     Orientation.Down       |1|
                          |2|3|4|
     
     Orientation.Left     |1|
                          |2|3|
                          |4|
     */
    
    override var blockDiffPositions: [Orientation : Array<(rowDiff: Int, columnDiff: Int)>] {
        return [
            Orientation.Up: [(0,0), (0,1), (0,2), (1,1)],
            Orientation.Right: [(0,1), (1,0), (1,1), (2,1)],
            Orientation.Down: [(0,1), (1,0), (1,1), (1,2)],
            Orientation.Left: [(0,0), (1,0), (1,1), (2,0)]
        ]
    }

    override var bottomBlocksWithOrientation: [Orientation : Array<Block>] {
        return [
            Orientation.Up: [blocks[0], blocks[2], blocks[3]],
            Orientation.Right: [blocks[1], blocks[3]],
            Orientation.Down: [blocks[1], blocks[2], blocks[3]],
            Orientation.Left: [blocks[2], blocks[3]]
        ]
    }
}
