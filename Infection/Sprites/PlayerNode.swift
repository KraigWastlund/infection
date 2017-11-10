//
//  PlayerNode.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    var isInfected = false
    var playerInfo: PlayerInfo!
    
    convenience init(size: CGSize, playerInfo: PlayerInfo) {
        
        self.init(imageNamed: "player")
        self.playerInfo = playerInfo
        self.size = size
        self.zPosition = 5
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = BitMask.player.rawValue
        self.physicsBody?.collisionBitMask = BitMask.wall.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.contactTestBitMask = BitMask.wall.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.name = "player"
        self.playerInfo = playerInfo
    }
}
