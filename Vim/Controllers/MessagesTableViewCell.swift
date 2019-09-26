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
            customize(message: message!)
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
    
    
    func customize(message: Message) {
        
        guard let user = message.chatPartner else {
            return
        }
        
        let name = user.name ?? user.email
        let surname = user.surname ?? ""
        self.nameLabel.text = name! + " " + surname
        self.contentTextLabel.text = self.message?.text
        if let imageData = user.imageData {
            let image = UIImage(data: imageData as Data)
            self.profileImageView.image = image
        }
    
        if let seconds = self.message?.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            if Calendar.current.isDateInToday(timestampDate) {
                dateFormatter.dateFormat = "HH:mm:ss"
            } else {
                dateFormatter.dateFormat = "EEEE"
            }
            
            self.dateLabel.text = dateFormatter.string(from: timestampDate)
            
        }
        
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 32
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.layoutIfNeeded()
        
    }

}
