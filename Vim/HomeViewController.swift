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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var posts: Array<Post> = []
    var friends: Array<User> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 420
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        refreshPostData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostData), name: NotificationNames.refreshPostData.notification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshPostData() {
        Loader.start()
        getSelfPostData()
        getFriendsPostData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = posts[indexPath.row]
        return cell
    }
    
    func getFriendsPostData() {
        let currentUser = User(email: Auth.auth().currentUser?.email, image: nil)
        FirestoreDb.shared.getFriends(currentUser: currentUser) { (friends) in
            self.friends.removeAll()
            self.friends.append(contentsOf: friends)
            for friendUser in friends {
                FirestoreDb.shared.getPostsData(currentUser: friendUser) { (passedArray) in
                    for post in passedArray {
                        let results = self.posts.filter {$0.text == post.text}
                        let exists = results.isEmpty == false
                        if exists {
                            self.posts.removeAll()
                        }
                    }
                    
                    self.posts.append(contentsOf: passedArray)
                    self.posts.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
                    Loader.stop()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getSelfPostData() {
        let currentUser = User(email: Auth.auth().currentUser?.email, image: nil)
        FirestoreDb.shared.getPostsData(currentUser: currentUser) { (passedArray) in
            for post in passedArray {
                let results = self.posts.filter {$0.text == post.text}
                let exists = results.isEmpty == false
                if exists {
                    self.posts.removeAll()
                }
            }
            self.posts.append(contentsOf: passedArray)
            self.posts.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
            Loader.stop()
            self.tableView.reloadData()
        }
    }
    

}
