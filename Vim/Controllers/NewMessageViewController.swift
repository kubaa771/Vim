//
//  NewMessageViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 09/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var friends: Array<User> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        tableView.delegate = self
        tableView.dataSource = self
        fetchFriends()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchFriends() {
        FirestoreDb.shared.getFriends() { [weak self] (friends) in
            self?.friends = friends
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendsListTableViewCell
        let friend = friends[indexPath.row]
        cell.model = friend
        cell.addFriendButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = friends[indexPath.row]
        let chatVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        navigationController?.show(chatVC, sender: nil)
    }
    

    //fetch friends, create tableView and by selecting row create segue to ChatVC(with data)
}
