//
//  ViewController.swift
//  Tetris
//
//  Created by ChaffulinLand on 2020/2/6.
//  Copyright © 2020 Chaffulin. All rights reserved.
//

import UIKit
import SpriteKit

var safeAreaTop: CGFloat = 0.0

class ViewController: UIViewController {

    // Swift typically enforces instantiation
    // Where you declare the variable or during initializer
    // To avoid this rule, we've added an ! after the type.
    var scene: GameScene!
    let tetris = Tetris()
    //Keep GameScene launch once
    var isGameSceneLaunched: Bool = false
    
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var nextShapeLable: UILabel!
    
    @IBAction func rotateTapped(_ sender: UIButton) {
        if scene.isCurrentShapeShouldStop() {
            return
        }
        
        if let current = currentShape {
        
            var nextOrientation = Orientation.rotate(orientation: current.orientation, clockwise: true)
        
            let isRotate = isRotateAvailable(currentShape: current, nextOrientation: nextOrientation)
            if !isRotate {
                nextOrientation = Orientation.rotate(orientation: current.orientation, clockwise: false)
                current.orientation = nextOrientation
                current.rotateBlocks(orientation: current.orientation)
            }
            
            bottomBlocks = current.bottomBlocksWithOrientation[current.orientation]
        }
    }
    
    @IBAction func moveLeftTapped(_ sender: UIButton) {
        if scene.isCurrentShapeShouldStop() {
            return
        }
        if let current = currentShape, let blocks = current.leftBlocksWithOrientation[current.orientation] {
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
        if let current = currentShape, let blocks = current.rightBlocksWithOrientation[current.orientation] {
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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *), let view = self.view {
            safeAreaTop = view.safeAreaInsets.top
        }
        
        if !isGameSceneLaunched {
            guard let skView = self.view as! SKView? else {
                return
            }
            skView.isMultipleTouchEnabled = false
            // Create and configure the scene.
            scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .aspectFill
            
            // Present the scene.
            skView.presentScene(scene)
            
            isGameSceneLaunched = true
        }        
    }

    func endGame() {
        rotateButton.isEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        downButton.isEnabled = false
    }
    
    // If lineShape will cover other shape after rotate, then do not allow this rotate
    func isRotateAvailable(currentShape: Shape, nextOrientation: Orientation) -> Bool {
        currentShape.rotateBlocks(orientation: nextOrientation)
        
        //left
        if let blocks = currentShape.leftBlocksWithOrientation[nextOrientation] {
            for block in blocks {
                if block.column <= 0 {
                    return false
                }
            }
        }
        
        //right
        if let blocks = currentShape.rightBlocksWithOrientation[nextOrientation] {
            for block in blocks {
                if block.column >= (NumColumns - 1) {
                    return false
                }
            }
        }
        
        //down
        if let blocks = currentShape.bottomBlocksWithOrientation[nextOrientation] {
            for block in blocks {
                if block.row >= (NumRows - 1) || boardArray[block.row + 1, block.column] != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isLargeScreen() -> Bool {
        if let screenHeight = UIScreen.main.currentMode?.size.height {
            if screenHeight >= 2436 {
                return true
            }
        }
        return false
    }
    
    func isSmallScreen() -> Bool {
        if let screenHeight = UIScreen.main.currentMode?.size.height {
            if screenHeight <= 1334 {
                return true
            }
        }
        return false
    }

}

