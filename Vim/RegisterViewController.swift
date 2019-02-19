//
//  RegisterViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var newEmail: String?
    var newPassword: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func emailTextFieldEdit(_ sender: UITextField) {
        newEmail = sender.text
    }

    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        newPassword = sender.text
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        Loader.start()
        if newEmail != nil, newPassword != nil {
            FirestoreDb.shared.addNewUser(givenEmail: newEmail!, givenPassword: newPassword!) { (finished) in
                if finished {
                    self.navigationController?.popViewController(animated: true)
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
