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
        updateView()
        //FirestoreDb.shared.addNewUser(user: first)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("deinit")
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
            FirestoreDb.shared.checkUserLogin(givenEmail: emailText!, givenPassword: passwordText!) { [weak self] (matched) in
                if matched {
                    //self?.dismiss(animated: true, completion: nil)
                    self?.performSegue(withIdentifier: "logged", sender: sender)
                    
                } else {
                    self?.displayErrorAlert(message: "Something went wrong, check your login, password or your internet connection!")
                }
                Loader.stop()
            }
        } else {
            Loader.stop()
            self.displayErrorAlert(message: "Please fulfill all the fields!")
        }
        
    }
    
}

