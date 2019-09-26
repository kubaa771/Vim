//
//  ChatLogViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var inputTextfield: UITextField = {
        let Textfield = UITextField()
        Textfield.translatesAutoresizingMaskIntoConstraints = false
        Textfield.placeholder = "Enter message..."
        Textfield.delegate = self
        return Textfield
    }()
    
    let containerView: UIView = {
        let cView = UIView()
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.backgroundColor = UIColor.white
        return cView
    }()
    
    var user: User! {
        didSet {
            let name = user.name ?? user.email
            let surname = user.surname ?? ""
            navigationItem.title = name! + " " + surname
            observeMessages()
            
        }
    }
    
    var messages = [Message]()
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ChatLogCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white//UIColor(patternImage: UIImage(named: "bg3.png")!)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        updateView(imageName: "bg3.png")
        self.tabBarController?.tabBar.isHidden = true
        setupInputComponents()
    }
    
    deinit {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func setupInputComponents() {
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        bottomConstraint.constant = 0
        bottomConstraint.identifier = "containerViewBottomConstraint"
        self.view.addConstraint(bottomConstraint)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        containerView.addSubview(inputTextfield)
        
        inputTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextfield.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        //inputTextfield.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inputTextfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        //separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 100)
        separatorLineView.backgroundColor = UIColor.lightGray
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend() {
        guard user != nil else {
            return
        }
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user.uuid
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSNumber(value: NSDate().timeIntervalSince1970)
        let values = ["text" : inputTextfield.text!, "toId" : toId, "fromId" : fromId, "timestamp" : timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            //let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            
            guard let messageId = childRef.key else {
                return
            }
            
            self.inputTextfield.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
            /*userMessagesRef.updateChildValues([messageId: 1])
            
            let recipentMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipentMessagesRef.updateChildValues([messageId : 1])*/
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for constraint in self.view.constraints {
            if constraint.identifier == "containerViewBottomConstraint" {
                constraint.constant = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(notification:)), name:  UIResponder.keyboardWillShowNotification, object: nil )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow( notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if #available(iOS 11.0, *) {
                newHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardFrame.cgRectValue.height
            }
            let keyboardHeight = newHeight // **10 is bottom margin of View**  and **this newHeight will be keyboard height**
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            for constraint in self.view.constraints {
                                if constraint.identifier == "containerViewBottomConstraint" {
                                    constraint.constant = keyboardHeight
                                }
                            }
                            self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerId() == self.user.uuid {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCollectionViewCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0, green: 0.5364930759, blue: 1, alpha: 1)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleRightAnchor?.isActive = true
            
        } else {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = false
        }
        
        DispatchQueue.main.async {
            if let userImageData = self.user.imageData {
                let image = UIImage(data: userImageData as Data)
                cell.profileImageView.image = image
            }
        }
        
        
        
        cell.bubbleWidthAnchor?.constant = estimatedSizeForText(text: message.text!).width + 32
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        if let text = messages[indexPath.row].text {
            height = estimatedSizeForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func estimatedSizeForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil)
    }
    
}
