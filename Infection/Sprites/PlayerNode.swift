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
    
<<<<<<< HEAD
    convenience init(width: CGFloat, height: CGFloat, playerInfo: PlayerInfo) {
        let texture = SKTexture(imageNamed: "player")
=======
    convenience init(size: CGSize, playerInfo: PlayerInfo) {
>>>>>>> 4a702be99440e4c310668d254110674de82526f0
        
        self.init(imageNamed: "player")
        self.playerInfo = playerInfo
        self.size = size
        self.zPosition = 5
<<<<<<< HEAD
//        self.physicsBody = SKPhysicsBody(circleOfRadius: 0.01)
        self.physicsBody?.categoryBitMask = BitMask.player.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitMask.wall.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = false
        self.name = "player"
        self.playerInfo = playerInfo
=======
//        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(3))
//        self.physicsBody?.categoryBitMask = BitMask.player.rawValue
//        self.physicsBody?.collisionBitMask = 0
//        self.physicsBody?.contactTestBitMask = BitMask.wall.rawValue | BitMask.bullet.rawValue
//        self.physicsBody?.isDynamic = true
//        self.physicsBody?.allowsRotation = true
//        self.physicsBody?.affectedByGravity = false
        self.name = playerInfo.name
>>>>>>> 4a702be99440e4c310668d254110674de82526f0
    }
}
