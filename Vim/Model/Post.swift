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
    
    init(date: Timestamp, text: String, image: UIImage?, imageData: NSData?) {
        self.date = date
        self.text = text
        self.imageData = imageData
        
        if let image = image {
            let data = NSData(data: image.jpegData(compressionQuality: 0.9)!)
            self.imageData = data
        }
    }
}
