//
//  MessagesViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 09/08/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(imageName: "bg3.png")
        //sendMessage()
        // Do any additional setup after loading the view.
    }
    
    func sendMessage() {
        let ref = Database.database().reference().child("messages")
        let values = ["text" : "tektsjakis"]
        ref.childByAutoId().updateChildValues(values)
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
