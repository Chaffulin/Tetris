//
//  Array2D.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/11.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

class Array2D<T> {
    
    let rows: Int
    let columns: Int
    
    var array: Array<T?>
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(row: Int, column: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
