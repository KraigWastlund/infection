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
    
    weak var parentViewController: GameViewController?
    private var titleLabel: SKLabelNode!
    private var startLabel: SKLabelNode!
    private var startButton: SKSpriteNode!
    
    private var settingsLabel: SKLabelNode!
    private var settingsButton: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        // Get label node from scene and store it for use later
        self.titleLabel = self.childNode(withName: "//titleLabel") as? SKLabelNode
        self.startLabel = self.childNode(withName: "//startLabel") as? SKLabelNode
        self.startButton = self.childNode(withName: "//startButton") as? SKSpriteNode
        self.settingsLabel = self.childNode(withName: "//settingsLabel") as? SKLabelNode
        self.settingsButton = self.childNode(withName: "//settingsButton") as? SKSpriteNode
        
        if let tLabel = self.titleLabel, let sLabel = startLabel, let sButton = startButton, let settingLabel = settingsLabel, let settingButton = settingsButton {
            tLabel.alpha = 0.0
            tLabel.run(SKAction.fadeIn(withDuration: 3.0))
            tLabel.run(SKAction.scale(by: 3.0, duration: 3.0))
            sLabel.alpha = 0.0
            sLabel.run(SKAction.fadeIn(withDuration: 3.0))
            sButton.alpha = 0.0
            sButton.run(SKAction.fadeIn(withDuration: 3.0))
            settingLabel.alpha = 0.0
            settingLabel.run(SKAction.fadeIn(withDuration: 3.0))
            settingButton.alpha = 0.0
            settingButton.run(SKAction.fadeIn(withDuration: 3.0))
        }
        self.setupMultipeerEventHandlers()
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
        
        if self.settingsButton.contains(pos) {
            settingsButtonPressed()
        }
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
        let height = 10
        let screenHeight = Int(self.size.height)
        let screenWidth = Int(self.size.width)
        let cellDimm = screenHeight / height
        let width = screenWidth / cellDimm
        
        let level = Level(width: width, height: height)
        level.renderLevel(mapSize: self.size)
        
        ConnectionManager.sendEvent(.startGame, object: ["level": SessionInfo(uuid: UUID(), levelString: Level.levelToString(level: level))])
        
        let playScene = PlayScene(level: level, size: self.size)
        playScene.view?.showsFPS = true
        playScene.view?.showsNodeCount = true
        self.view?.presentScene(playScene)
    }
    
    private func settingsButtonPressed() {
        self.parentViewController!.openSettingsController()
    }
    
    fileprivate func setupMultipeerEventHandlers() {
        ConnectionManager.onEvent(.startGame) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            let sessionInfo = SessionInfo(mpcSerialized: dict["level"]! as Data)
            
            let level = Level.stringToLevel(levelString: sessionInfo.levelString)
            level.renderLevel(mapSize: self.size)
            
            let playScene = PlayScene(level: level, size: self.size)
            playScene.view?.showsFPS = true
            playScene.view?.showsNodeCount = true
            self.view?.presentScene(playScene)
        }
    }
}
