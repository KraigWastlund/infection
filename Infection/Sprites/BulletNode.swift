//
//  BulletNode.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit

class BulletNode: SKSpriteNode {
    convenience init(width: CGFloat, height: CGFloat) {
        let texture = SKTexture(imageNamed: "ninja-star")
        
        self.init(texture: texture, color: UIColor.white, size: CGSize(width: width, height: height))
        self.zPosition = 5
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(3))
        self.physicsBody?.categoryBitMask = BitMask.bullet.rawValue
        self.physicsBody?.collisionBitMask = BitMask.wall.rawValue | BitMask.player.rawValue
        self.physicsBody?.contactTestBitMask = BitMask.wall.rawValue | BitMask.player.rawValue
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.name = "Bullet"
        self.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1.0)))
    }
}

