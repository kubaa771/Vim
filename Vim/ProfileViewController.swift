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
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()

        // Do any additional setup after loading the view.
    }
    
    func customize() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        //FirestoreDb.shared.getUserProfileData(email: Auth.auth().currentUser?.email, completion: <#T##(User) -> Void#>)
        changeRequest?.displayName = "lol"
        changeRequest?.commitChanges(completion: { (error) in
            print(error ?? "error")
        })
        let user = Auth.auth().currentUser
        if let user = user {
            nameLabel.text = user.displayName
            emailLabel.text = user.email
        }
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
