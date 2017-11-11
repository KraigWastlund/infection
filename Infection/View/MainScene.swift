//
//  MainScene.swift
//  Infection
//
//  Created by Kraig Timpson 11/9/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainScene: SKScene {
        
    private var titleLabel: SKLabelNode!
    private var startLabel: SKLabelNode!
    private var startButton: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        // Get label node from scene and store it for use later
        self.titleLabel = self.childNode(withName: "//titleLabel") as? SKLabelNode
        self.startLabel = self.childNode(withName: "//startLabel") as? SKLabelNode
        self.startButton = self.childNode(withName: "//startButton") as? SKSpriteNode
        
        if let tLabel = self.titleLabel, let sLabel = startLabel, let sButton = startButton {
            tLabel.alpha = 0.0
            tLabel.run(SKAction.fadeIn(withDuration: 3.0))
            tLabel.run(SKAction.scale(by: 3.0, duration: 3.0))
            sLabel.alpha = 0.0
            sLabel.run(SKAction.fadeIn(withDuration: 3.0))
            sButton.alpha = 0.0
            sButton.run(SKAction.fadeIn(withDuration: 3.0))
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
        
    }
    
    private func startButtonWasPressed() {
        let playScene = PlayScene(size: self.size)
        playScene.view?.showsFPS = true
        playScene.view?.showsNodeCount = true
        self.view?.presentScene(playScene)
    }
}
