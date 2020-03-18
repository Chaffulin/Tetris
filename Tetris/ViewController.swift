//
//  ViewController.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/6.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    // Swift typically enforces instantiation
    // Where you declare the variable or during initializer
    // To avoid this rule, we've added an ! after the type.
    var scene: GameScene!
    let tetris = Tetris()

    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    @IBAction func rotateTapped(_ sender: UIButton) {
        if scene.isCurrentShapeShouldStop() {
            return
        }
        
        let nextOrientation = Orientation.rotate(orientation: currentOrientation, clockwise: true)
        
        if let current = currentShape {
            
            let isRotate = isRotateAvailable(currentShape: current, nextOrientation: nextOrientation)
            if isRotate {
                currentOrientation = nextOrientation
            }
            
            current.rotateBlocks(orientation: currentOrientation)
            bottomBlocks = current.bottomBlocksWithOrientation[currentOrientation]
        
        
        }
    }
    
    @IBAction func moveLeftTapped(_ sender: UIButton) {
        if scene.isCurrentShapeShouldStop() {
            return
        }
        if let current = currentShape, let blocks = current.leftBlocksWithOrientation[currentOrientation] {
            for block in blocks {
                if block.column <= 0 || (boardArray[block.row, block.column - 1] != nil) {
                    return
                }
            }
            current.moveBy(rows: 0, columns: -1)
        }        
    }
    @IBAction func moveRightTapped(_ sender: UIButton) {
        if scene.isCurrentShapeShouldStop() {
            return
        }
        if let current = currentShape, let blocks = current.rightBlocksWithOrientation[currentOrientation] {
            for block in blocks {
                if block.column >= 9 || (boardArray[block.row, block.column + 1] != nil) {
                    return
                }
            }
            current.moveBy(rows: 0, columns: 1)
        }
    }
    @IBAction func moveDownTapped(_ sender: UIButton) {
        if let bottomBlocks = bottomBlocks {
            for block in bottomBlocks {
                // add all bottom blocks to bottomBlocks
                if block.row == (NumRows - 2)
                    || (boardArray[block.row + 1, block.column] != nil) || (boardArray[block.row + 2, block.column] != nil) {
                    return
                }
            }
        }
        currentShape?.moveBy(rows: 2, columns: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
    }

    func endGame() {
        rotateButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        downButton.isEnabled = false
    }
    
    // If lineShape will cover other shape after rotate, then do not allow this rotate
    func isRotateAvailable(currentShape: Shape, nextOrientation: Orientation) -> Bool {
        if currentShape.shapeType == ShapeType.Squere && (nextOrientation == Orientation.Up || nextOrientation == Orientation.Down) {
            if let blocks = currentShape.bottomBlocksWithOrientation[nextOrientation] {
                for block in blocks {
                    if boardArray[block.row + 1, block.column] != nil {
                        return false
                    }
                }
            }
        }
        return true
    }
}

