//
//  User.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

class User {
    var login: String!
    var password: String!
    var email: String!
    
    init(login: String, password: String, email: String?) {
        self.login = login
        self.password = password
        self.email = email
    }
}
