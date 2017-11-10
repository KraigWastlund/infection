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

class PlayScene: SKScene {
    
    private var graphs = [String : GKGraph]()
    private let PLAYER_SPEED = CGFloat(30)
    private var player: PlayerNode!
    private var lastUpdateTime : TimeInterval = 0
    
    private var player: PlayerNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
<<<<<<< HEAD
        let level = Level(width: 10, height: 10)
        level.renderLevel(mapSize: self.size)
=======
        let info = PlayerInfo(uuid: UUID(), name: "bob", position: CGPoint(x: 50, y: 50), velocity: CGVector(dx: 0, dy: 0))
        player = PlayerNode(size: CGSize(width: 0.1, height: 0.1), playerInfo: info)
        guard let _ = player else { return }
>>>>>>> 4a702be99440e4c310668d254110674de82526f0
        
        let level = Level(width: 10, height: 10)
        level.renderLevel(mapSize: self.size)

        for wall in level.walls {
            self.addChild(wall)
        }
        
<<<<<<< HEAD
//        let texture = SKTexture(imageNamed: "player")
//        let node = SKSpriteNode(texture: texture, color: UIColor.white, size: CGSize(width: 0.2, height: 0.2))
//        node.position = CGPoint(x: 0.2, y: 0.2)
//        self.addChild(node)
        
        let playerInfo = PlayerInfo(uuid: UUID(),name: "hello! :)", position: CGPoint(x: 0, y: 0), velocity: CGVector(dx: 0, dy: 0))
        player = PlayerNode(width: 0.05, height: 0.05, playerInfo: playerInfo)
        player.position = CGPoint(x: 0.15, y: 0.15)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.05, height: 0.05))
=======
>>>>>>> 4a702be99440e4c310668d254110674de82526f0
        self.addChild(player)
        
        //        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        //        swipeRight.direction = .right
        //        view.addGestureRecognizer(swipeRight)
        //
        //        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        //        swipeLeft.direction = .left
        //        view.addGestureRecognizer(swipeLeft)
        //
        //        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        //        swipeUp.direction = .up
        //        view.addGestureRecognizer(swipeUp)
        //
        //        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        //        swipeDown.direction = .down
        //        view.addGestureRecognizer(swipeDown)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        print(pos)
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
    //    func swipedRight(_ sender:UISwipeGestureRecognizer){
    //        player.physicsBody?.applyForce(CGVector(dx: PLAYER_SPEED,dy: 0))
    //    }
    //
    //    func swipedLeft(_ sender:UISwipeGestureRecognizer){
    //        player.physicsBody?.applyForce(CGVector(dx: -PLAYER_SPEED,dy: 0))
    //    }
    //
    //    func swipedUp(_ sender:UISwipeGestureRecognizer){
    //        player.physicsBody?.applyForce(CGVector(dx: 0,dy: PLAYER_SPEED))
    //    }
    //
    //    func swipedDown(_ sender:UISwipeGestureRecognizer){
    //        player.physicsBody?.applyForce(CGVector(dx: 0,dy: -PLAYER_SPEED))
    //    }
}

