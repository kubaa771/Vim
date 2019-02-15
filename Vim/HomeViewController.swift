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
        FirestoreDb.shared.getPostsData(currentUserEmail: (Auth.auth().currentUser?.email)!) { (passedArray) in
            self.posts = passedArray
            self.posts.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = posts[indexPath.row]
        
        return cell
    }
    

    @IBAction func newPostAction(_ sender: UIBarButtonItem) {
        //stworzyc nowy vc
        //FirestoreDb.shared.createNewPost(currentEmail: (Auth.auth().currentUser?.email)!, date: Firebase.Timestamp.init(date: Date()), text: "MY abdksdhjas hdhjjdhj kansdkj ajkndskjanskd jkankjndjk kbnkjrnrjkr k sjd jsjsd jsdnjsjnsdjn sjdsndjs")
    }
    

}
