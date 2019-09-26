//
//  ChatLogCollectionViewCell.swift
//  Vim
//
//  Created by Jakub Iwaszek on 15/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class ChatLogCollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 16.0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    let bubbleView: UIView = {
        let bView = UIView()
        bView.backgroundColor = #colorLiteral(red: 0, green: 0.5364930759, blue: 1, alpha: 1)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 16
        bView.layer.masksToBounds = true
        return bView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user_male.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        //insertSubview(textView, aboveSubview: bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        /*textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true*/
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
