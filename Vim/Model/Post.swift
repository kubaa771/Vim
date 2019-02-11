//
//  Post.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Post {
    var date: Timestamp!
    var text: String!
    
    init(date: Timestamp, text: String) {
        self.date = date
        self.text = text
    }
}
