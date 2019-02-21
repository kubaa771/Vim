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
    var photo: UIImage?
    
    init(email: String?, image: UIImage?) {
        self.email = email
        self.photo = image
    }
}
