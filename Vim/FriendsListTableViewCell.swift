//
//  FriendsListTableViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 26/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    weak var delegate: AddFriendProtocolDelegate?
    
    var model: User! {
        didSet {
            customize(user: model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func customize(user: User) {
        nameLabel.text = user.email
    }
    

    @IBAction func addFriendButtonAction(_ sender: UIButton) {
        delegate?.addFriendButtonTapped(cell: self)
    }
    
}
