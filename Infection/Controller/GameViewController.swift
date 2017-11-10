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
//        skView = self.view as! SKView
//        skView.ignoresSiblingOrder = true
//        skView.backgroundColor = UIColor.clearColor()
//
//        if SPCYSettings.spcyDebugToggle() == true {
//            debuggingMode()
//        }
//
//        mainMenu = MainScene(size: view.frame.size)
//        mainMenu!.managedObjectContext = managedObjectContext
//        skView.presentScene(mainMenu)
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                player.position = CGPoint(x: 10, y: 10)
                
                sceneNode.addChild(player)
                
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
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
        self.player.position = CGPoint(x: self.player.position.x + 10, y: self.player.position.y + 10)
        ConnectionManager.sendEvent(.position, object: ["player": Player(uuid: UUID(),name: "hello! :)", position: self.player.position)])
    }
    
    // MARK: Multipeer
    
    fileprivate func setupMultipeerEventHandlers() {
        ConnectionManager.onEvent(.position) { [unowned self] peer, object in
            let dict = object as! [String: NSData]
            let testObject = Player(mpcSerialized: dict["player"]! as Data)
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
    }
}
