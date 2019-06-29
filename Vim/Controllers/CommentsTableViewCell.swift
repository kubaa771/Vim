//
//  CommentsTableViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 27/06/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var model: Comment! {
        didSet {
            customize(comment: model)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func customize(comment: Comment) {
        if let profileImageData = comment.user.imageData {
            let image = UIImage(data: profileImageData as Data)
            
            userImageView.layer.masksToBounds = false
            
            userImageView.layer.cornerRadius = 20
            userImageView.clipsToBounds = true
            userImageView.contentMode = UIView.ContentMode.scaleAspectFill//imageData    NSData?    0x000060000322d3c0
            userImageView.image = image
            self.layoutIfNeeded()
        }
        let name = comment.user.name ?? comment.user.email
        let surname = comment.user.surname ?? ""
        userNameLabel.text = name! + " " + surname
        let date = comment.date.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        commentDateLabel.text = strDate
        commentTextLabel.text = comment.text
    }

}
