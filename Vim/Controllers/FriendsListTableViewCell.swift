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
    @IBOutlet weak var friendProfilePictureView: UIImageView!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.friendProfilePictureView.image = UIImage(named: "user_male.jpg")
    }

    func customize(user: User) {
        let name = user.name ?? user.email
        let surname = user.surname ?? ""
        nameLabel.text = name! + " " + surname
        if let imageData = user.imageData {
            let image = UIImage(data: imageData as Data)
            friendProfilePictureView.layer.masksToBounds = false
            friendProfilePictureView.layer.cornerRadius = 30
            friendProfilePictureView.clipsToBounds = true
            friendProfilePictureView.contentMode = UIView.ContentMode.scaleAspectFill
            friendProfilePictureView.image = image
            self.layoutIfNeeded()
        }
    }
    

    @IBAction func addFriendButtonAction(_ sender: UIButton) {
        delegate?.addFriendButtonTapped(cell: self)
    }
    
}
