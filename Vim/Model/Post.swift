//
//  Post.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Post: HashableClass {
    var date: Timestamp!
    var text: String!
    var imageData: NSData!
    var owner: User!
    var uuid = UUID().uuidString
    var whoLiked: Array<String>?
    
    init(date: Timestamp, text: String, image: UIImage?, imageData: NSData?, owner: User, id: String, whoLiked: Array<String>?) {
        self.date = date
        self.text = text
        self.imageData = imageData
        self.owner = owner
        self.uuid = id
        self.whoLiked = whoLiked
        
        if let image = image {
            let data = NSData(data: image.jpegData(compressionQuality: 0.6)!)
            self.imageData = data
        }
    }
}
