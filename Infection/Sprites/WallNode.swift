//
//  WallNode.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit

enum WallOrientation {
    case horizontal
    case vertical
}

class WallNode: SKSpriteNode {
    convenience init(width: CGFloat, height: CGFloat, orientation: WallOrientation) {
        var texture: SKTexture!
        if orientation == .horizontal {
            texture = SKTexture(imageNamed: "wall_h")
        } else {
            texture = SKTexture(imageNamed: "wall_v")
        }
        assert(texture != nil, "we failed?!")
        
        self.init(texture: texture, color: UIColor.white, size: CGSize(width: width, height: height))
        self.zPosition = 0
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        self.physicsBody?.categoryBitMask = BitMask.wall.rawValue
        self.physicsBody?.collisionBitMask = BitMask.player.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.contactTestBitMask = BitMask.player.rawValue | BitMask.bullet.rawValue
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0
        self.name = "Wall"
    }
}
