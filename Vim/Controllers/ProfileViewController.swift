//
//  ProfileViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 27/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostOptionsDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var friendsButtonOutlet: UIButton!
    @IBOutlet weak var postsButtonOutlet: UIButton!
    
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    
    
    var allPosts: Array<Post> = []
    var friends: Array<User> = []
    var currentUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 420
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        updateView(imageName: "bg3.png")
        customize()
        NotificationCenter.default.addObserver(self, selector: #selector(customize), name: NotificationNames.refreshProfile.notification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func customize() {
        self.emailLabel.text = ""
        self.nameLabel.text = ""
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 62
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        let user = Auth.auth().currentUser
        Loader.start()
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.currentUser = userData
            self.emailLabel.text = "  " + (user?.email)!
            self.nameLabel.text = " " + userData.name! + " " + userData.surname!
            if let imgData = userData.imageData {
                self.profileImageView.image = UIImage(data: imgData as Data)
            }
            self.getSelfPostData()
        }
        
        FirestoreDb.shared.getFriends { (friends) in
            //sprawdzic czy friend istnieje
            self.friendsButtonOutlet.setTitle(String(friends.count) + " " + "Friends", for: .normal)
        }
        
        //getSelfPostData()
    }
    
    func getSelfPostData() {
        guard currentUser != nil else { return }
        FirestoreDb.shared.getPostsData(currentUser: currentUser) { (passedArray) in
            var myPosts = passedArray
            for post in passedArray {
                let results = self.allPosts.filter {$0.uuid == post.uuid}
                let exists = results.isEmpty == false
                if exists {
                    myPosts.removeAll()
                }
            }
            self.allPosts.append(contentsOf: myPosts)
            self.allPosts.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
            self.postsButtonOutlet.setTitle(String(self.allPosts.count) + " " + "Posts", for: .normal)
            self.tableView.reloadData()
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
            //self.scrollViewHeightConstraint.constant = self.tableView.contentSize.height
            self.scrollView.contentSize.height = self.tableView.contentSize.height
            Loader.stop()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = allPosts[indexPath.row]
        cell.delegate = self
        cell.indexCell = indexPath
        return cell
    }

    @IBAction func friendsButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendListTableViewController") as! FriendsListTableViewController
        vc.isUserFriendsList = true
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.show(vc, sender: nil)
        //self.show(vc, sender: nil)
    }
    
    func postLikedButtonAction(cell: HomeTableViewCell) {
        guard let currentUserID = currentUser?.uuid else { return }
        if (cell.model.whoLiked?.contains(currentUserID))! {
            FirestoreDb.shared.unlikedPost(whoUnliked: currentUser, likedPost: cell.model) { (likes) in
                self.allPosts[cell.indexCell.row] = Post(date: cell.model.date, text: cell.model.text, image: nil, imageData: cell.model.imageData, owner: cell.model.owner, id: cell.model.uuid, whoLiked: likes)
                self.tableView.reloadRows(at: [cell.indexCell], with: .automatic)
            }
            
        } else {
            FirestoreDb.shared.likedPost(whoLiked: currentUser, likedPost: cell.model) { (likes) in
                self.allPosts[cell.indexCell.row] = Post(date: cell.model.date, text: cell.model.text, image: nil, imageData: cell.model.imageData, owner: cell.model.owner, id: cell.model.uuid, whoLiked: likes)
                self.tableView.reloadRows(at: [cell.indexCell], with: .automatic)
            }
            
        }
        
    }
    
    func commentSectionButtonTappedAction(cell: HomeTableViewCell) {
        //
    }
    
    

}
