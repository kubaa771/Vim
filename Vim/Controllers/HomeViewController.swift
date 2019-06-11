//
//  HomeViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostLikedProtocolDelegate {
   
    var allPosts: Array<Post> = []
    var friends: Array<User> = []
    var currentUser: User!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        customize()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 420
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostData), name: NotificationNames.refreshPostData.notification, object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.refreshPostData),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        tableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshPostData() {
        allPosts.removeAll()
        Loader.start()
        getFriendsPostData()
        getSelfPostData()
    }
    
    func customize() {
        let user = Auth.auth().currentUser
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.currentUser = userData
            self.refreshPostData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        if !tableView.refreshControl!.isRefreshing {
            cell.model = allPosts[indexPath.row]
            cell.delegate = self
            cell.indexCell = indexPath
        }
        return cell
    }
    
    func getFriendsPostData() {
        FirestoreDb.shared.getFriends() { (friends) in
            let group = DispatchGroup()
            self.friends.removeAll()
            self.friends.append(contentsOf: friends)
            for friendUser in friends {
                group.enter()
                FirestoreDb.shared.getPostsData(currentUser: friendUser) { (passedArray) in
                    var postsfriends: Array<Post> = passedArray
                    for post in passedArray {
                        let results = self.allPosts.filter {$0.uuid == post.uuid}
                        let exists = results.isEmpty == false
                        if exists {
                            postsfriends.removeAll()
                        }
                    }
                    group.leave()
                    self.allPosts.append(contentsOf: postsfriends)
                    self.allPosts.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
                    
                }
            }
            
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    Loader.stop()
                }
                
               
            }
           
        }
        
    }
    
    func getSelfPostData() {
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
        }
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

}
