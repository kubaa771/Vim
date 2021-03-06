//
//  Protocols.swift
//  Vim
//
//  Created by Jakub Iwaszek on 26/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation


protocol AddFriendProtocolDelegate: AnyObject {
    func addFriendButtonTapped(cell: FriendsListTableViewCell)
}


protocol PostOptionsDelegate: AnyObject {
    func postLikedButtonAction(cell: HomeTableViewCell)
    func commentSectionButtonTappedAction(cell: HomeTableViewCell)
}

protocol FriendsListDelegate: AnyObject {
    func showFriendsList(cell: ProfileHeaderView)
}
