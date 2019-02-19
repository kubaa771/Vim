//
//  HomeTableViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
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
        imageHeight.constant = 0
    }
    
    func customize(post: Post) {
        let date = post.date.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        dateLabel.text = strDate
        postContentLabel.text = post.text
        if let imageData = post.imageData {
            let image = UIImage(data: imageData as Data)
            postImageView.image = image
            let ratio = image!.size.width / image!.size.height
            let newHeight = postImageView.frame.width / ratio
            imageHeight.constant = newHeight
            self.layoutIfNeeded()
        }
    }

}
