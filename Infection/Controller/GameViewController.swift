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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "MainScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! MainScene? {
                sceneNode.scaleMode = .aspectFill
                sceneNode.parentViewController = self
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
    
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        return [ .bottom, .top ]
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func openSettingsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.present(settingsVC, animated: true, completion: nil)
    }
}
