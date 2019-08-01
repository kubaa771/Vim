//
//  HomeTableViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var ownerPictureImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var currentUser = Auth.auth().currentUser
    
    var indexCell: IndexPath!
    
    weak var delegate: PostOptionsDelegate?
    
    var model: Post! {
        didSet {
            customize(post: model)
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
        
        self.postImageView.image = nil
        self.ownerPictureImageView.image = UIImage(named: "user_male.jpg")
        imageHeight.constant = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func customize(post: Post) {
       
        if let imageData = post.imageData {
            let image = UIImage(data: imageData as Data)
            let ratio = image!.size.width / image!.size.height
            let newHeight = postImageView.frame.width / ratio
            imageHeight.constant = newHeight
            postImageView.image = image
            self.layoutIfNeeded()
        }
        
        if let profileImageData = post.owner.imageData {
            let image = UIImage(data: profileImageData as Data)
            
            ownerPictureImageView.layer.masksToBounds = false
            
            ownerPictureImageView.layer.cornerRadius = 26
            ownerPictureImageView.clipsToBounds = true
            ownerPictureImageView.contentMode = UIView.ContentMode.scaleAspectFill//imageData    NSData?    0x000060000322d3c0
            ownerPictureImageView.image = image
            self.layoutIfNeeded()
        }
        
        let date = post.date.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        dateLabel.text = strDate
        postContentLabel.text = post.text
        let name = post.owner.name ?? post.owner.email
        let surname = post.owner.surname ?? ""
        userLabel.text = name! + " " + surname //dokoncz
        let commentsNumber = post.commentsNumber ?? 0
        commentsLabel.text = String(commentsNumber)
        guard let likes = post.whoLiked?.count else { return }
        likeNumber.text = String(likes)
        guard let currentUserID = currentUser?.uid else { return }
        if (post.whoLiked?.contains(currentUserID))! {
            likeButton.setImage(UIImage(named: "redheart.png"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heart.png"), for: .normal)
        }
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        delegate?.postLikedButtonAction(cell: self)
    }
    
    @IBAction func commentSectionButtonTapped(_ sender: UIButton) {
        delegate?.commentSectionButtonTappedAction(cell: self)
    }
    
}
