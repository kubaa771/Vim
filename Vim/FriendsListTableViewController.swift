//
//  FriendsListTableViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 25/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class FriendsListTableViewController: UITableViewController, AddFriendProtocolDelegate {
    
    var allUsersArray: Array<User> = []
    var userFriendsArray: Array<User> = []
    let currentUser = User(email: Auth.auth().currentUser?.email, image: nil, name: nil, surname: nil, id: UUID().uuidString)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 81
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        modelSetUp()
    }
    
    func modelSetUp() {
        FirestoreDb.shared.getAllUsers { (usersList) in
            self.allUsersArray = usersList
            self.tableView.reloadData()
        }
        FirestoreDb.shared.getFriends(currentUser: currentUser) { (friends) in
            self.userFriendsArray = friends
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendsListTableViewCell
        cell.model = allUsersArray[indexPath.row]
        cell.delegate = self

        return cell
    }
    
    func addFriendButtonTapped(cell: FriendsListTableViewCell) {
        if userFriendsArray.contains(where: {$0.email == cell.model.email}){
            displayErrorAlert(message: "You are already friends.")
        } else if cell.model.email == currentUser.email {
            displayErrorAlert(message: "It's you!")
        } else {
            FirestoreDb.shared.addFriend(currentUser: currentUser, userToAdd: cell.model)
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            UIView.animate(withDuration: 1.5) {
                cell.backgroundColor = UIColor.clear
            }
        }
    }
    
    

}
