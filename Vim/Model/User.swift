//
//  User.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit

class User {
    var email: String!
    var photo: NSData?
    var name: String?
    var surname: String?
    var uuid = UUID().uuidString
    
    init(email: String?, image: NSData?, name: String?, surname: String?, id: String) {
        self.email = email
        self.photo = image
        self.name = name
        self.surname = surname
        self.uuid = id
    }
}
