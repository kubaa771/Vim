//
//  MessagesViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 09/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        observeUserMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let group = DispatchGroup()
        
        Loader.start()
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            group.enter()
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String : Any] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    
                    if let toId = message.chatPartnerId() {
                        if toId != Auth.auth().currentUser?.uid {
                            FirestoreDb.shared.getUserProfileData(userID: toId) { (user) in
                                message.chatPartner = user
                                group.leave()
                            }
                            self.messagesDictionary[toId] = message
                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sort(by: { (m1, m2) -> Bool in
                                return m1.timestamp!.intValue > m2.timestamp!.intValue
                            })
                        }
                        
                    }
                    
                    group.notify(queue: .main, execute: {
                        Loader.stop()
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTableViewRefresh), userInfo: nil, repeats: false)
                    })
                    
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
        
        
    }
    
    var timer: Timer?
    
    @objc func handleTableViewRefresh() {
        //DispatchQueue.main.async {
            self.tableView.reloadData()
        
        //}
    }
    
    /*func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (m1, m2) -> Bool in
                        return m1.timestamp!.intValue > m2.timestamp!.intValue
                    })
                }
                
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = message.chatPartner
        navigationController?.show(chatVC, sender: nil)
    }
    
    

}
