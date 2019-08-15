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
        return cView
    }()
    
    var user: User! {
        didSet {
            let name = user.name ?? user.email
            let surname = user.surname ?? ""
            navigationController?.title = name! + " " + surname
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white//UIColor(patternImage: UIImage(named: "bg3.png")!)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
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
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        <#code#>
    }
    

    
}
