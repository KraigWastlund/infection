//
//  WallNode.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit

class WallNode: SKSpriteNode {
    convenience init(width: CGFloat, height: CGFloat) {
        let texture = SKTexture(imageNamed: "Wall")
        
        self.init(texture: texture, color: UIColor.white, size: CGSize(width: width, height: height))
        self.zPosition = 0
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(3))
        self.physicsBody?.categoryBitMask = BitMask.wall.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.name = "Wall"
    }
}
