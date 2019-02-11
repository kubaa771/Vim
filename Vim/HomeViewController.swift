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
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //zmienic na notyfikacje - odbierac jak cos sie zmienilo i wywolywac ta funkcje
        FirestoreDb.shared.getPostsData(currentUserEmail: (Auth.auth().currentUser?.email)!) { (passedArray) in
            self.posts = passedArray
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
        FirestoreDb.shared.createNewPost(currentEmail: (Auth.auth().currentUser?.email)!, date: Firebase.Timestamp.init(date: Date()), text: "My third post")
    }
    

}
