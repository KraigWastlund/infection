//
//  PlayScene.swift
//  Infection
//
//  Created by Kraig Wastlund on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BitMask: UInt32 {
    case player = 1
    case wall = 2
    case bullet = 4
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

class PlayScene: SKScene {
    
    private var graphs = [String : GKGraph]()
    private let PLAYER_SPEED = CGFloat(30)
    private var lastUpdateTime : TimeInterval = 0
    
    private var player: PlayerNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        let info = PlayerInfo(uuid: UUID(), name: "bob", position: CGPoint(x: 455, y: 500), velocity: CGVector(dx: 0, dy: 0))
        player = PlayerNode(size: CGSize(width: 50, height: 50), playerInfo: info)
        
        let level = Level(width: 10, height: 10)
        level.renderLevel(mapSize: self.size)

        for wall in level.walls {
            self.addChild(wall)
        }   
        
        self.addChild(player)
        player.position = player.playerInfo.position
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        let projectile = SKSpriteNode(imageNamed: "ninja-star")
        projectile.size = CGSize(width: 30, height: 30)
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = pos - projectile.position
        
        //        if (offset.x < 0) { return }
        
        addChild(projectile)
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
    }
}

extension PlayScene {
    @objc func swipedRight(_ sender:UISwipeGestureRecognizer){
        player.physicsBody?.applyForce(CGVector(dx: PLAYER_SPEED,dy: 0))
    }

    @objc func swipedLeft(_ sender:UISwipeGestureRecognizer){
        player.physicsBody?.applyForce(CGVector(dx: -PLAYER_SPEED,dy: 0))
    }

    @objc func swipedUp(_ sender:UISwipeGestureRecognizer){
        player.physicsBody?.applyForce(CGVector(dx: 0,dy: PLAYER_SPEED))
    }

    @objc func swipedDown(_ sender:UISwipeGestureRecognizer){
        player.physicsBody?.applyForce(CGVector(dx: 0,dy: -PLAYER_SPEED))
    }
}

