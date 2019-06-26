//
//  SettingsViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 18/06/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(imageName: "bg3.png")
        self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logoutBarButtonAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logoutSegue", sender: nil)
            
        } catch {
            //error
            print("error while signingout")
        }
        
    }

}
