//
//  Player.swift
//  Infection
//
//  Created by PJ Vea on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit
import MultipeerConnectivity

private let myName = UIDevice.current.name

class Player: MPCSerializable {
    var uuid: UUID!
    var name: String!
    var position: CGPoint!
    var velocity: CGVector!
    
    var me: Bool { return self.name == myName }
    var displayName: String { return self.me ? "You" : self.name }
    
    init(uuid: UUID!, name: String, position: CGPoint, velocity: CGVector) {
        self.uuid = uuid
        self.name = name
        self.position = position
        self.velocity = velocity
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(peer: MCPeerID) {
        self.name = peer.displayName
    }
    
    static func getMe() -> Player {
        return Player(name: myName)
    }
    
    var mpcSerialized: Data {
        let dictionary = ["uuid": self.uuid, "name": self.name, "position": self.position, "velocity": self.velocity] as [String : Any]
        return NSKeyedArchiver.archivedData(withRootObject: dictionary)
    }
    
    required init(mpcSerialized: Data) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: mpcSerialized) as! [String: Any]
        self.uuid = dict["uuid"]! as! UUID
        self.name = dict["name"]! as! String
        self.position = dict["position"]! as! CGPoint
        self.velocity = dict["velocity"]! as! CGVector
    }
}
