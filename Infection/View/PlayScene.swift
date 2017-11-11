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
    private let PLAYER_SPEED = CGFloat(1000)
    private var initialLoadTime: TimeInterval?
    private var players: [PlayerNode] = []
    private var player: PlayerNode!
    private var updateCounter = 0
    fileprivate var playerSize: Double!
    fileprivate var cameraSet = false
    fileprivate var level: Level!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(level: Level, size: CGSize) {
        self.init(size: size)
        self.level = level
        
        for wall in level.walls {
            self.addChild(wall)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.physicsWorld.contactDelegate = self
        
        let height = 10
        let screenHeight = Int(self.size.height)
        let screenWidth = Int(self.size.width)
        let cellDimm = screenHeight / height
        
        self.playerSize = Double(cellDimm) * 0.65
        
        let myXPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(screenHeight / 2)
        let myYPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(screenWidth / 2)
        
        let info = PlayerInfo(uuid: UUID(), name: UIDevice.current.name, position: CGPoint(x: myXPos, y: myYPos))
        player = PlayerNode(size: CGSize(width: self.playerSize, height: self.playerSize), playerInfo: info)
        player.position = player.playerInfo.position
        
        self.addChild(player)
        self.backgroundColor = .lightGray
        
        for playerInfo in ConnectionManager.otherPlayers {
            let xPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(screenHeight / 2)
            let yPos = CGFloat( Float(arc4random()) / Float(UINT32_MAX)) * CGFloat(screenWidth / 2)
            playerInfo.position = CGPoint(x: xPos, y: yPos)
            let player = PlayerNode(size: CGSize(width: self.playerSize, height: self.playerSize), playerInfo: playerInfo)
            player.position = playerInfo.position
            
            self.players.append(player)
            self.addChild(player)
        }
        
        self.setupMultipeerEventHandlers()
    }

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.showsPhysics = false
        
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
        if initialLoadTime == nil {
            initialLoadTime = currentTime
        }
        
        if (player.physicsBody?.velocity.dx)! < CGFloat(0) {
            player.xScale = -1.0
        }
        if (player.physicsBody?.velocity.dx)! > CGFloat(0) {
            player.xScale = 1.0
        }
        
        updateCounter += 1
        if updateCounter > 10 {
            self.player.playerInfo.position = self.player.position
            ConnectionManager.sendEvent(.playerInfo, object: ["playerInfo": self.player.playerInfo])
        }
        
        if cameraSet {
            camera!.run(SKAction.move(to: player.position, duration: 0.1))
        } else {
            guard let time = initialLoadTime else { return }
            
            if self.camera == nil && currentTime - time > 2 {
                let cameraNode = SKCameraNode()
                cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(cameraNode)
                self.camera = cameraNode
                let delay = SKAction.wait(forDuration: 0.25)
                let group = SKAction.group([SKAction.scale(to: 0.35, duration: 1.0), SKAction.move(to: player.position, duration: 1.0)])
                camera!.run(SKAction.sequence( [ delay, group ]), completion: {
                    self.cameraSet = true
                })
            }
        }
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
            break
//            player.velocity = CGVector(dx: 0, dy: 0)
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

// MARK: Multipeer

extension PlayScene {
    
    fileprivate func setupMultipeerEventHandlers() {
        ConnectionManager.onEvent(.startGame) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
//            let sessionInfo = SessionInfo(mpcSerialized: dict["level"]! as Data)
//            print(sessionInfo.levelString)
        }
        
        ConnectionManager.onEvent(.playerInfo) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            let playerInfo = PlayerInfo(mpcSerialized: dict["playerInfo"]! as Data)
            DispatchQueue.main.async {
                let filteredPlayers = self.players.filter({ $0.playerInfo.name == playerInfo.name })
                if !filteredPlayers.isEmpty, let filteredPlayer = filteredPlayers.first {
                    filteredPlayer.position = playerInfo.position
                    SKAction.move(to: playerInfo.position, duration: 2)
                } else {
                    self.player.position = playerInfo.position
                    SKAction.move(to: playerInfo.position, duration: 2)
                }
            }
        }
        
        ConnectionManager.onEvent(.actionInfo) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            print(dict)
        }
        
        ConnectionManager.onEvent(.endGame) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            print(dict)
        }
    }
}

