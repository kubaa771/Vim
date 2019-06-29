//
//  CommentsViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 26/06/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var datePostLabel: UILabel!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var photoPostImageView: UIImageView!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    @IBOutlet weak var photoPostHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentUser = Auth.auth().currentUser
    var postModel: Post! = nil
    var comments: Array<Comment> = [Comment(user: User(email: "test123@gmail.com", imageData: nil, name: "Test", surname: "Test", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", uuid: UUID().uuidString), Comment(user: User(email: "inny@gmail.com", imageData: nil, name: "Test", surname: "Tessssssssssssssst", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet", uuid: UUID().uuidString), Comment(user: User(email: "test123@gmail.com", imageData: nil, name: "Te", surname: "st", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", uuid: UUID().uuidString), Comment(user: User(email: "inny@gmail.com", imageData: nil, name: "Name", surname: "Surname", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum", uuid: UUID().uuidString), Comment(user: User(email: "test123@gmail.com", imageData: nil, name: "User", surname: "Wisnakannxwoanwuyasknyskjyans", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", uuid: UUID().uuidString), Comment(user: User(email: "inny@gmail.com", imageData: nil, name: "Test", surname: "T", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", uuid: UUID().uuidString), Comment(user: User(email: "inny@gmail.com", imageData: nil, name: "Test", surname: "T", id: UUID().uuidString), date: Firebase.Timestamp.init(date: Date()), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", uuid: UUID().uuidString)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        guard postModel != nil else { return }
        customize(post: postModel)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func customize(post: Post) {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "paper_plane.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        //button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
        
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
        commentsNumberLabel.text = String(comments.count)
        guard let currentUserID = currentUser?.uid else { return }
        if (post.whoLiked?.contains(currentUserID))! {
            likeButton.setImage(UIImage(named: "redheart.png"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heart.png"), for: .normal)
        }
        
        tableView.reloadData()
        
        //tableViewHeightConstraint.constant = tableView.contentSize.height * 2
        //tableView.contentSize.height = scrollView.contentSize.height
        //scrollViewHeightConstraint.constant = tableView.contentSize.height
        //scrollView.contentSize.height = tableView.contentSize.height
        //tableView.frame.size.height = tableView.contentSize.height
        
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height + 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsTableViewCell
        cell.model = comments[indexPath.row]
        return cell
    }
    
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        textFieldBottomConstraint.constant = 0
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        //
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
                            self.textFieldBottomConstraint.constant = keyboardHeight
                                self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
}
