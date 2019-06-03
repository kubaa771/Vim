//
//  ProfileViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 27/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 62
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        let user = Auth.auth().currentUser
        Loader.start()
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.emailLabel.text = "  " + (user?.email)!
            self.nameLabel.text = " " + userData.name! + " " + userData.surname!
            if let imgData = userData.imageData {
                self.profileImageView.image = UIImage(data: imgData as Data)
            }
            Loader.stop()
        }
        
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.currentUser = userData
            self.getSelfPostData()
        }
        
        /*if let user = user {
            nameLabel.text = user.displayName
            emailLabel.text = user.email
        }*/
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
            self.tableView.reloadData()
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
            //self.scrollViewHeightConstraint.constant = self.tableView.contentSize.height
            self.scrollView.contentSize.height = self.tableView.contentSize.height + 100
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.model = allPosts[indexPath.row]
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
