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

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    private var graphs = [String : GKGraph]()
    private let PLAYER_SPEED = CGFloat(2000)
    private var lastUpdateTime : TimeInterval = 0
    private var player: PlayerNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.physicsWorld.contactDelegate = self
        
        let level = Level(width: 10, height: 10)
        level.renderLevel(mapSize: self.size)
        
        for wall in level.walls {
            self.addChild(wall)
        }   
        
        let info = PlayerInfo(uuid: UUID(), name: "bob", position: CGPoint(x: 50, y: 50), velocity: CGVector(dx: 0, dy: 0))
        player = PlayerNode(size: CGSize(width: 40, height: 40), playerInfo: info)
        player.position = player.playerInfo.position
        
        self.addChild(player)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.showsPhysics = true
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
    }
    
    func touchDown(atPoint pos : CGPoint) {
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
        if let touch = touches.first, touches.count == 1 {
            if isFiringTouch(touch: touch) {
                fireBullet(at: touch.location(in: self))
            }
        } else {
            for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        }
    }
    
    func isFiringTouch(touch: UITouch) -> Bool {
        let pos = touch.preciseLocation(in: self.view)
        let prevPos = touch.previousLocation(in: self.view)
        let thisDistance = distance(between: pos, and: prevPos)
        
        return thisDistance == 0.0
    }
    
    func distance(between a: CGPoint, and b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
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
        
        self.lastUpdateTime = currentTime
    }
}

extension PlayScene {
    
    fileprivate func fireBullet(at pos: CGPoint) {
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        let projectile = BulletNode(width: 20, height: 20)
        projectile.position = player.position
        addChild(projectile)
        
        let offset = pos - projectile.position
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.move(to: realDest, duration: 5.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case BitMask.player.rawValue | BitMask.wall.rawValue:
            player.playerInfo.velocity = CGVector(dx: 0, dy: 0)
        case BitMask.bullet.rawValue | BitMask.wall.rawValue:
            let bullet = contact.bodyB.node
            bullet?.removeFromParent()
        case BitMask.bullet.rawValue | BitMask.player.rawValue:
            let player = contact.bodyA.node
            if player != self.player {
                // bullet has hit another player
                let bullet = contact.bodyB.node
                bullet?.removeFromParent()
            }
        default:
            break
        }
    }
}

