//
//  Level.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit
import SpriteKit

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

class Cell {
    var xPos = 0
    var yPos = 0
    var hasLeftWall = true
    var hasRightWall = true
    var hasTopWall = true
    var hasBottomWall = true
    var visited = false
    
    convenience init(xPos: Int, yPos: Int, leftWall: Bool, rightWall: Bool, topWall: Bool, bottomWall: Bool) {
        
        self.init()
        self.xPos = xPos
        self.yPos = yPos
        self.hasLeftWall = leftWall
        self.hasRightWall = rightWall
        self.hasTopWall = topWall
        self.hasBottomWall = bottomWall
    }
}

class Level {
    var walls = [WallNode]()
    var cells = [Cell]()
    var height = 0
    var width = 0

    convenience init(width: Int, height: Int) {
        self.init()
        
        self.width = width
        self.height = height
        self.walls = [WallNode]()
        
        for j in 0..<height {
            for i in 0..<width {
                let cell = Cell(xPos: i, yPos: j, leftWall: true, rightWall: true, topWall: true, bottomWall: true)
                cells.append(cell)
            }
        }
        
        carveWalls(xPos: 0, yPos: 0)
    }
    
    static func levelToString(level: Level) -> String {
        var levelString = ""
        levelString += "\(level.width)-\(level.height)"
        for cell in level.cells {
            levelString += "-\(cell.xPos).\(cell.yPos).\(NSNumber(value: cell.hasLeftWall).intValue)\(NSNumber(value: cell.hasRightWall).intValue)\(NSNumber(value: cell.hasTopWall).intValue)\(NSNumber(value: cell.hasBottomWall).intValue)"
        }
        return levelString
    }
    
    static func stringToLevel(levelString: String) -> Level {
        var separatedByDash = levelString.components(separatedBy: "-")
        let width = Int(separatedByDash[0])!
        separatedByDash.remove(at: 0)
        let height = Int(separatedByDash[0])!
        separatedByDash.remove(at: 0)
        
        let level = Level(width: width, height: height)
        level.cells.removeAll()
        
        for stringValue in separatedByDash {
            var separatedByPeriod = stringValue.components(separatedBy: ".")
            let xPos = Int(separatedByPeriod[0])!
            let yPos = Int(separatedByPeriod[1])!
            let characters = Array(String(separatedByPeriod[2]))
            let leftWall = Bool(truncating: NSNumber(value: Int(String(characters[0]))!))
            let rightWall = Bool(truncating: NSNumber(value: Int(String(characters[1]))!))
            let topWall = Bool(truncating: NSNumber(value: Int(String(characters[2]))!))
            let bottomWall = Bool(truncating: NSNumber(value: Int(String(characters[3]))!))
            let cell = Cell(xPos: xPos, yPos: yPos, leftWall: leftWall, rightWall: rightWall, topWall: topWall, bottomWall: bottomWall)
            level.cells.append(cell)
        }
        return level
    }
    
    func renderLevel(mapSize: CGSize) {
        let widthOfCell = mapSize.width / CGFloat(width)
        let heightOfCell = mapSize.height / CGFloat(height)
        
        for cell in cells {
            if cell.hasLeftWall {
                let wallNode = WallNode(width: widthOfCell*0.25, height: heightOfCell, orientation: .vertical)
                let xPos = CGFloat(cell.xPos) * widthOfCell
                let yPos = CGFloat(cell.yPos) * heightOfCell + heightOfCell/2
                wallNode.position = CGPoint(x: xPos, y: yPos)
                walls.append(wallNode)
            }
            
            if cell.hasRightWall {
                let wallNode = WallNode(width: widthOfCell*0.25, height: heightOfCell, orientation: .vertical)
                let xPos = CGFloat(cell.xPos + 1) * widthOfCell
                let yPos = CGFloat(cell.yPos) * heightOfCell + heightOfCell/2
                wallNode.position = CGPoint(x: xPos, y: yPos)
                walls.append(wallNode)
            }
            
            if cell.hasTopWall {
                let wallNode = WallNode(width: widthOfCell, height: heightOfCell*0.25, orientation: .horizontal)
                let xPos = CGFloat(cell.xPos) * widthOfCell + widthOfCell/2
                let yPos = CGFloat(cell.yPos + 1) * heightOfCell
                wallNode.position = CGPoint(x: xPos, y: yPos)
                walls.append(wallNode)
            }
            
            if cell.hasBottomWall {
                let wallNode = WallNode(width: widthOfCell, height: heightOfCell*0.25, orientation: .horizontal)
                let xPos = CGFloat(cell.xPos) * widthOfCell + widthOfCell/2
                let yPos = CGFloat(cell.yPos) * heightOfCell
                wallNode.position = CGPoint(x: xPos, y: yPos)
                walls.append(wallNode)
            }
        }
    }
    
    func carveWalls(xPos: Int, yPos: Int) {
        var cellsToVisit = [Cell]()
        let index = xPos + yPos * width
        let currentCell = cells[index]
        currentCell.visited = true
        
        if xPos > 0 {
            let leftCell = cells[index - 1]
            if !leftCell.visited {
                cellsToVisit.append(leftCell)
            }
        }
        
        if xPos < (width - 1) {
            let rightCell = cells[index + 1]
            if !rightCell.visited {
                cellsToVisit.append(rightCell)
            }
        }
        
        if yPos > 0 {
            let bottomCell = cells[index - width]
            if !bottomCell.visited {
                cellsToVisit.append(bottomCell)
            }
        }
        
        if yPos < (height - 1) {
            let topCell = cells[index + width]
            if !topCell.visited {
                cellsToVisit.append(topCell)
            }
        }
        
        cellsToVisit = cellsToVisit.shuffled()
        
        for nextCell in cellsToVisit {
            
            // Left Cell
            if nextCell.yPos == yPos && nextCell.xPos < xPos {
                if nextCell.visited == false {
                    currentCell.hasLeftWall = false
                    nextCell.hasRightWall = false
                    carveWalls(xPos: xPos - 1, yPos: yPos)
                }
            }
            
            // Right Cell
            if nextCell.yPos == yPos && nextCell.xPos > xPos {
                if nextCell.visited == false {
                    currentCell.hasRightWall = false
                    nextCell.hasLeftWall = false
                    carveWalls(xPos: xPos + 1, yPos: yPos)
                }
            }
            
            // Bottom Cell
            if nextCell.xPos == xPos && nextCell.yPos < yPos {
                if nextCell.visited == false {
                    currentCell.hasBottomWall = false
                    nextCell.hasTopWall = false
                    carveWalls(xPos: xPos, yPos: yPos - 1)
                }
            }
            
            // Top Cell
            if nextCell.xPos == xPos && nextCell.yPos > yPos {
                if nextCell.visited == false {
                    currentCell.hasTopWall = false
                    nextCell.hasBottomWall = false
                    carveWalls(xPos: xPos, yPos: yPos + 1)
                }
            }
        }
    }
}
