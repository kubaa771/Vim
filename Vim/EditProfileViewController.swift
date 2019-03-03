//
//  EditProfileViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 03/03/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    var newName: String?
    var newPassword: String?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nameTextFieldEdit(_ sender: UITextField) {
        newName = sender.text
    }
    
    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        newPassword = sender.text
    }
    
    
    @IBAction func chooseFromGalleryAction(_ sender: UIButton) {
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        FirestoreDb.shared.updateUserProfile(auth: auth, newName: newName, newPassword: newPassword) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.displayErrorAlert(message: "Something went wrong. Try again later!")
            }
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
