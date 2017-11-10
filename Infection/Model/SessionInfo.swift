//
//  SessionInfo.swift
//  Infection
//
//  Created by PJ Vea on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit

class SessionInfo: MPCSerializable {
    var uuid: UUID!
    var level: Level!
    
    init(uuid: UUID!, level: Level) {
        self.uuid = uuid
        self.level = level
    }
    
    var mpcSerialized: Data {
        let dictionary = ["uuid": self.uuid, "level": self.level] as [String : Any]
        return NSKeyedArchiver.archivedData(withRootObject: dictionary)
    }
    
    required init(mpcSerialized: Data) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: mpcSerialized) as! [String: Any]
        self.uuid = dict["uuid"]! as! UUID
        self.level = dict["level"]! as! Level
    }
}
