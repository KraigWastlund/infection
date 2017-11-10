//
//  MPCAttributedString.swift
//  Infection
//
//  Created by PJ Vea on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit

struct MPCAttributedString: MPCSerializable {
    let attributedString: NSAttributedString
    
    var mpcSerialized: Data {
        return NSKeyedArchiver.archivedData(withRootObject: attributedString)
    }
    
    init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    init(mpcSerialized: Data) {
        let attributedString = NSKeyedUnarchiver.unarchiveObject(with: mpcSerialized) as! NSAttributedString
        self.init(attributedString: attributedString)
    }
}
