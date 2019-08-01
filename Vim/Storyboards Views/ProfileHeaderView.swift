//
//  ProfileHeaderView.swift
//  Vim
//
//  Created by Jakub Iwaszek on 12/07/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class ProfileHeaderView: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var friendsButtonOutlet: UIButton!
    @IBOutlet weak var postsButtonOutlet: UIButton!
    
    weak var delegate: FriendsListDelegate?
    
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
        emailLabel.text = "  " + (user.email)!
        nameLabel.text = " " + user.name! + " " + user.surname!
        if let imgData = user.imageData {
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.cornerRadius = 62
            profileImageView.clipsToBounds = true
            profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
            profileImageView.image = UIImage(data: imgData as Data)
        }
    }
    
    
    @IBAction func friendsTappedAction(_ sender: UIButton) {
        delegate?.showFriendsList(cell: self)
    }
    
}
