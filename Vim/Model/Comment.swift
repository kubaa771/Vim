//
//  Comment.swift
//  Vim
//
//  Created by Jakub Iwaszek on 27/06/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Comment {
    var user: User!
    var date: Timestamp!
    var text: String!
    var uuid = UUID().uuidString
    
    init(user: User, date: Timestamp, text: String, uuid: String) {
        self.user = user
        self.date = date
        self.text = text
        self.uuid = uuid
    }
    
}
