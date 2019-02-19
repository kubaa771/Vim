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
    var friends: Array<String> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        refreshPostData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostData), name: NotificationNames.refreshPostData.notification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshPostData() {
        Loader.start()
        FirestoreDb.shared.getPostsData(currentUserEmail: (Auth.auth().currentUser?.email)!) { (passedArray) in
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
        getFriends()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = posts[indexPath.row]
        
        return cell
    }
    
    func getFriends() {
        FirestoreDb.shared.getFriends(currentEmail: (Auth.auth().currentUser?.email)!) { (friends) in
            self.friends.removeAll()
            self.friends.append(contentsOf: friends)
            for friendEmail in friends {
                FirestoreDb.shared.getPostsData(currentUserEmail: friendEmail) { (passedArray) in
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
    

}
