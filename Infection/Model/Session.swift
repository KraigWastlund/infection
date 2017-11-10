//
//  Session.swift
//  Infection
//
//  Created by PJ Vea on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit

class Session: MPCSerializable {
    var uuid: UUID!
    
    init(uuid: UUID!) {
        self.uuid = uuid
    }
    
    var mpcSerialized: Data {
        let dictionary = ["uuid": self.uuid] as [String : Any]
        return NSKeyedArchiver.archivedData(withRootObject: dictionary)
    }
    
    required init(mpcSerialized: Data) {
        let dict = NSKeyedUnarchiver.unarchiveObject(with: mpcSerialized) as! [String: Any]
        self.uuid = dict["uuid"]! as! UUID
    }
}
