//
//  LoginViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var emailText: String?
    var passwordText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirestoreDb.shared.addNewUser(user: first)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func emailTextFieldTyped(_ sender: UITextField) {
        emailText = sender.text
    }
    
    @IBAction func passwordTextFieldTyped(_ sender: UITextField) {
        passwordText = sender.text
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        Loader.start()
        if emailText != nil, passwordText != nil {
            FirestoreDb.shared.checkUserLogin(givenEmail: emailText!, givenPassword: passwordText!) { (matched) in
                if matched {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    self.showDetailViewController(vc, sender: sender)
                } else {
                    self.displayErrorAlert(message: "Something went wrong, check your login or password!")
                }
                Loader.stop()
            }
        } else {
            Loader.stop()
            self.displayErrorAlert(message: "Please fulfill all the fields!")
        }
        
    }
    
}
