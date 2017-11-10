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

        let level = Level(width: 10, height: 14)
        level.renderLevel(mapSize: self.size)
        
        for wall in level.walls {
            self.addChild(wall)
        }
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
