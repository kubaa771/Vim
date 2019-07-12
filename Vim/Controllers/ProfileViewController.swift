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


    @IBOutlet weak var tableView: UITableView!
    
    var allPosts: Array<Post> = []
    var friends: Array<User> = []
    var currentUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 420
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 180
        customize()
        NotificationCenter.default.addObserver(self, selector: #selector(customize), name: NotificationNames.refreshProfile.notification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func customize() {
        let user = Auth.auth().currentUser
        Loader.start()
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.currentUser = userData
            self.getSelfPostData()
        }
        
        FirestoreDb.shared.getFriends { (friends) in
            self.friends = friends
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
            self.tableView.reloadData()
            self.tableView.isHidden = false
            Loader.stop()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = allPosts[indexPath.row]
        cell.delegate = self
        cell.indexCell = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as! ProfileHeaderView
        headerView.friendsButtonOutlet.setTitle(String(friends.count) + " " + "Friends", for: .normal)
        headerView.postsButtonOutlet.setTitle(String(allPosts.count) + " " + "Posts", for: .normal)
        if currentUser != nil {
            headerView.model = currentUser
        }
        return headerView
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
