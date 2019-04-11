//
//  ProfileViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 27/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var lock = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        NotificationCenter.default.addObserver(self, selector: #selector(customize), name: NotificationNames.refreshProfile.notification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func customize() {
        let user = Auth.auth().currentUser
        Loader.start()
        FirestoreDb.shared.getUserProfileData(userID: (user?.uid)!) { (userData) in
            self.emailLabel.text = user?.email
            self.nameLabel.text = userData.name
            self.surnameLabel.text = userData.surname
            if let imgData = userData.imageData {
                self.profileImageView.image = UIImage(data: imgData as Data)
            }
            Loader.stop()
            if self.lock {
                self.nameLabel.addBorder(toSide: .Bottom, withColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), andThickness: 1)
                self.surnameLabel.addBorder(toSide: .Bottom, withColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), andThickness: 1)
                self.emailLabel.addBorder(toSide: .Bottom, withColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), andThickness: 1)
                self.lock = false
            }
            
            
            
        }
        /*if let user = user {
            nameLabel.text = user.displayName
            emailLabel.text = user.email
        }*/
    }
    

    @IBAction func friendsButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendListTableViewController") as! FriendsListTableViewController
        vc.isUserFriendsList = true
        self.navigationController?.pushViewController(vc, animated: true)
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
