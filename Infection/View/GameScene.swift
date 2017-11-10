//
//  GameScene.swift
//  Infection
//
//  Created by Kraig Timpson 11/9/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BitMask: UInt32 {
    case player = 1
    case wall = 2
    case bullet = 4
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    let PLAYER_SPEED = CGFloat(30)
    let playerInfo = PlayerInfo(uuid: UUID(),name: "hello! :)", position: CGPoint(x: 0, y: 0), velocity: CGVector(dx: 0, dy: 0))
    var player: PlayerNode!
    
    private var lastUpdateTime : TimeInterval = 0
    private var titleLabel: SKLabelNode!
    private var startLabel: SKLabelNode!
    private var startButton: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.titleLabel = self.childNode(withName: "//titleLabel") as? SKLabelNode
        self.startLabel = self.childNode(withName: "//startLabel") as? SKLabelNode
        self.startButton = self.childNode(withName: "//startButton") as? SKSpriteNode
        
        if let tLabel = self.titleLabel, let sLabel = startLabel, let sButton = startButton {
            tLabel.alpha = 0.0
            tLabel.run(SKAction.fadeIn(withDuration: 3.0))
            tLabel.run(SKAction.scale(by: 2.0, duration: 3.0))
            sLabel.alpha = 0.0
            sLabel.run(SKAction.fadeIn(withDuration: 3.0))
            sButton.alpha = 0.0
            sButton.run(SKAction.fadeIn(withDuration: 3.0))
            
            tLabel.isUserInteractionEnabled = false
            sLabel.isUserInteractionEnabled = false
            sButton.isUserInteractionEnabled = false
        }
        
        player = PlayerNode(width: 50, height: 50, playerInfo: playerInfo)
        player.position = CGPoint(x: 0, y: 0)
        self.addChild(player)
        
        let level = Level(width: 14, height: 8)
        
        let mapSize = CGSize(width: self.size.width, height: (750*750)/self.size.height)
        
        level.renderLevel(mapSize: mapSize)
        
        for wall in level.walls {
            self.addChild(wall)
        }
        
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
        
        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if self.startButton.contains(pos) {
            self.startButton.alpha = 0.5
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if self.startButton.contains(pos) {
            startButtonWasPressed()
        }
        self.startButton.alpha = 1.0
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
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    private func startButtonWasPressed() {
        let playScene = PlayScene()
        self.view?.presentScene(playScene)
    }
}

extension GameScene {
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
