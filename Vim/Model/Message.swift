//
//  Message.swift
//  Vim
//
//  Created by Jakub Iwaszek on 09/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    @objc var text: String?
    @objc var toId: String?
    @objc var fromId: String?
    @objc var timestamp: NSNumber?
    
    var chatPartner: User?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
