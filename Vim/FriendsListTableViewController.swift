//
//  FriendsListTableViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 25/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class FriendsListTableViewController: UITableViewController, AddFriendProtocolDelegate, UISearchResultsUpdating {
   
    var allUsersArray: Array<User> = []
    var userFriendsArray: Array<User> = []
    var filteredUsersArray: Array<User> = []
    var isUserFriendsList: Bool = false
    var currentUser: User!
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        setupSearchController()
        tableView.estimatedRowHeight = 81
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(modelSetUp), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    func customize() {
        let user = Auth.auth().currentUser
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.currentUser = userData
            self.modelSetUp()
        }
    }
    
    @objc func modelSetUp() {
        Loader.start()
        FirestoreDb.shared.getAllUsers { (usersList) in
            self.allUsersArray = usersList
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            Loader.stop()
        }
        if !isUserFriendsList {
           
            
            FirestoreDb.shared.getFriends() { (friends) in
                self.userFriendsArray = friends
                self.tableView.reloadData()
                Loader.stop()
            }
        } else {
            FirestoreDb.shared.getFriends() { (friends) in
                self.userFriendsArray.removeAll()
                for friend in friends {
                    let checker = self.checkIfFriendExists(user: friend)
                    if checker {
                        self.userFriendsArray.append(friend)
                    }
                }
                self.allUsersArray = self.userFriendsArray
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    Loader.stop()
                }
            }
        }
    }
    
    func checkIfFriendExists(user: User) -> Bool{
        if allUsersArray.contains(where: {$0.uuid == user.uuid}) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredUsersArray.count
        }
        return allUsersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendsListTableViewCell
        let user: User!
        if isFiltering() {
            user = filteredUsersArray[indexPath.row]
        } else {
            user = allUsersArray[indexPath.row]
        }
        cell.model = user
        cell.delegate = self

        return cell
    }
    
    func addFriendButtonTapped(cell: FriendsListTableViewCell) {
        if userFriendsArray.contains(where: {$0.email == cell.model.email}){
            displayErrorAlert(message: "You are already friends.")
        } else if cell.model.email == currentUser.email {
            displayErrorAlert(message: "It's you!")
        } else {
            FirestoreDb.shared.addFriend(userToAdd: cell.model)
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            UIView.animate(withDuration: 1.5) {
                cell.backgroundColor = UIColor.clear
            }
        }
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
    
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContent(for searchText: String) {
        if allUsersArray.count > 0 {
            filteredUsersArray = allUsersArray.filter({(user : User) -> Bool in
                return user.email.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    

}
