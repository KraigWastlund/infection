//
//  GameViewController.swift
//  Infection
//
//  Created by Kraig Wastlund on 11/9/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var player = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMultipeerEventHandlers()
        
        if let scene = GKScene(fileNamed: "MainScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! MainScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                player.position = CGPoint(x: 10, y: 10)
                sceneNode.parentViewController = self
                
//                sceneNode.addChild(player)
                
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func sendAction(_ sender: Any) {
        ConnectionManager.sendEvent(.startGame, object: ["level": SessionInfo(uuid: UUID(), level: Level(width: 100, height: 100))])
        self.player.position = CGPoint(x: self.player.position.x + 10, y: self.player.position.y + 10)
        ConnectionManager.sendEvent(.playerInfo, object: ["playerInfo": PlayerInfo(uuid: UUID() ,name: "hello! :)", position: self.player.position, velocity: CGVector(dx: 0, dy: 0))])
        ConnectionManager.sendEvent(.actionInfo, object: ["actionInfo": ActionInfo(uuid: UUID(), position: CGPoint(x: 10, y: 10), velocity: CGVector(dx: 0, dy: 0))])
        ConnectionManager.sendEvent(.endGame)
    }
    
    func openSettingsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    // MARK: Multipeer
    
    fileprivate func setupMultipeerEventHandlers() {
        ConnectionManager.onEvent(.startGame) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            let testObject = SessionInfo(mpcSerialized: dict["level"]! as Data)
            print(testObject.uuid)
            print(testObject.level.width)
            print(testObject.level.height)
        }
        
        ConnectionManager.onEvent(.playerInfo) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            let testObject = PlayerInfo(mpcSerialized: dict["playerInfo"]! as Data)
            print(testObject.uuid)
            print(testObject.name)
            print(testObject.position)
            print("ALL PLAYERS: ")
            for player in ConnectionManager.allPlayers {
                print(player.name)
                print(player.displayName)
            }
            print("OTHER PLAYERS: ")
            for player in ConnectionManager.otherPlayers {
                print(player.name)
                print(player.displayName)
            }
            self.player.position = testObject.position
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
