//
//  PlayerInfo.swift
//  Infection
//
//  Created by PJ Vea on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit
import MultipeerConnectivity

private let myName = UIDevice.current.name

class PlayerInfo: MPCSerializable {
    var uuid: UUID!
    var name: String!
    var position: CGPoint!
    var isInfected: Bool!
    
    var me: Bool { return self.name == myName }
    var displayName: String { return self.me ? "You" : self.name }
    
    init(name: String, position: CGPoint) { // assume uuid is set
        self.name = name
        self.position = position
        if self.uuid == nil {
            self.uuid = UUID()
        }
    }
    
    init(name: String) {
        self.name = name
        if self.uuid == nil {
            self.uuid = UUID()
        }
    }
    
    init(peer: MCPeerID) {
        self.name = peer.displayName
        if self.uuid == nil {
            self.uuid = UUID()
        }
    }
    
    static func getMe() -> PlayerInfo {
        return PlayerInfo(name: myName)
    }
    
    var mpcSerialized: Data {
        let dictionary = ["uuid": self.uuid, "name": self.name, "position": self.position] as [String : Any]
        return NSKeyedArchiver.archivedData(withRootObject: dictionary)
    }
    
    required init(mpcSerialized: Data) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: mpcSerialized) as! [String: Any]
        self.uuid = dict["uuid"]! as! UUID
        self.name = dict["name"]! as! String
        self.position = dict["position"]! as! CGPoint
    }
}
