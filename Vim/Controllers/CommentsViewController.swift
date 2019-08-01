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

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var userFB = Auth.auth().currentUser
    var userData: User! = nil
    var postModel: Post! = nil
    var commentText: String?
    var comments: Array<Comment> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 269
        tableView.tableFooterView = UIView()
        guard postModel != nil else { return }
        customize()
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func customize() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "paper_plane.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.commentPost), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
        
        fetchData()
    }
    
    func fetchData() {
        Loader.start()
        FirestoreDb.shared.getUserProfileData(userID: (userFB?.uid)!) { (userData) in
            self.userData = userData
        }
        
        FirestoreDb.shared.getComments(from: postModel) { (comments) in
            self.comments = comments
            self.comments.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
            self.postModel.commentsNumber = comments.count
            self.tableView.reloadData()
            Loader.stop()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsTableViewCell
        cell.model = comments[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HomeTableViewCell
        headerView.model = postModel
        return headerView
    }
    
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        textFieldBottomConstraint.constant = 0
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        commentText = sender.text
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
    
    @objc func commentPost() {
        if commentText != nil, userData != nil {
            let comment = Comment(user: userData, date: Firebase.Timestamp.init(date: Date()), text: commentText!, uuid: UUID().uuidString)
            FirestoreDb.shared.commentPost(commentedPost: postModel, comment: comment)
            textField.text = ""
            fetchData()
            
        }
    }
    
}
