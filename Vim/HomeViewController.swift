//
//  HomeViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    var posts: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreDb.shared.getUserData(currentUserEmail: (Auth.auth().currentUser?.email)!) { (passedArray) in
            self.posts = passedArray
            print(self.posts ?? "")
        }
        print(posts ?? "")
        // Do any additional setup after loading the view.
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
