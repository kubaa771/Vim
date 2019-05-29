//
//  NotificationNames.swift
//  Vim
//
//  Created by Jakub Iwaszek on 15/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation

enum NotificationNames: String {
    case refreshPostData = "refreshPostData"
    case refreshProfile = "refreshProfile"
    case refreshLikeButtonState = "refreshLikeButtonState"
    
    var notification: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}
