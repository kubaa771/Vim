//
//  HeaderView.swift
//  Vim
//
//  Created by Jakub Iwaszek on 01/07/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class HeaderView: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var datePostLabel: UILabel!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var photoPostImageView: UIImageView!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    @IBOutlet weak var photoPostHeightConstraint: NSLayoutConstraint!
    
    var model: Post! {
        didSet {
            customize(post: model)
        }
    }
    
    var currentUser = Auth.auth().currentUser

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize(post: Post) {
        if let imageData = post.imageData {
            let image = UIImage(data: imageData as Data)
            let ratio = image!.size.width / image!.size.height
            let newHeight = photoPostImageView.frame.width / ratio
            photoPostHeightConstraint.constant = newHeight
            photoPostImageView.image = image
        }
        
        if let profileImageData = post.owner.imageData {
            let image = UIImage(data: profileImageData as Data)
            
            userImageView.layer.masksToBounds = false
            userImageView.layer.cornerRadius = 26
            userImageView.clipsToBounds = true
            userImageView.contentMode = UIView.ContentMode.scaleAspectFill
            userImageView.image = image
        }
        
        let date = post.date.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        datePostLabel.text = strDate
        textPostLabel.text = post.text
        let name = post.owner.name ?? post.owner.email
        let surname = post.owner.surname ?? ""
        userNameLabel.text = name! + " " + surname //dokoncz
        guard let likes = post.whoLiked?.count else { return }
        likeNumberLabel.text = String(likes)
        //commentsNumberLabel.text = String(comments.count)
        guard let currentUserID = currentUser?.uid else { return }
        if (post.whoLiked?.contains(currentUserID))! {
            likeButton.setImage(UIImage(named: "redheart.png"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heart.png"), for: .normal)
        }
        
    }
    
    
}
