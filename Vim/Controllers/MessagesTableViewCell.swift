//
//  MessagesTableViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 12/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var message: Message? {
        didSet {
            profileImageView.image = UIImage(named: "user_male.jpg")
            updateUserLog()
            if let seconds = self.message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                self.dateLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    private func updateUserLog() {
        
        if let id = message?.chatPartnerId() {
            FirestoreDb.shared.getUserProfileData(userID: id) { (user) in
                self.message?.chatPartner = user
                let name = user.name ?? user.email
                let surname = user.surname ?? ""
                self.nameLabel.text = name! + " " + surname
                self.contentTextLabel.text = self.message?.text
                if let imageData = user.imageData {
                    let image = UIImage(data: imageData as Data)
                    self.profileImageView.image = image
                    self.layoutIfNeeded()
                }
                
            }
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
        self.profileImageView.image = UIImage(named: "user_male.jpg")
    }
    
    override func layoutSubviews() {
        customize()
    }
    
    func customize() {
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 32
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.layoutIfNeeded()
        
    }

}
