//
//  LoginViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var first = User(login: "mistic123", password: "admin", email: "cso@gmail.com")
    var loginText: String? //zmienic na ?
    var passwordText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirestoreDb.shared.addNewUser(user: first)
        
    }
    
    
    @IBAction func loginTextFieldTyped(_ sender: UITextField) {
        loginText = sender.text
    }
    
    
    @IBAction func passwordTextFieldTyped(_ sender: UITextField) {
        passwordText = sender.text
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if loginText != nil, passwordText != nil {
            FirestoreDb.shared.checkUserLogin(givenLogin: loginText!, givenPassword: passwordText!) { (matched) in
                if matched {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    self.showDetailViewController(vc, sender: sender)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong, check your login or password!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
}
