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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func emailTextFieldEdit(_ sender: UITextField) {
        newEmail = sender.text
    }

    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        newPassword = sender.text
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        if newEmail != nil, newPassword != nil {
            FirestoreDb.shared.addNewUser(givenEmail: newEmail!, givenPassword: newPassword!) { (finished) in
                if finished {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong, check your login or password!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
