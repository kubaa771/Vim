//
//  FirestoreDb.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDb {
    
    static let shared = FirestoreDb()
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    
    init() {
        //docRef = Firestore.firestore().document("users")
    }
    
    func addNewUser(user: User) {
        db.collection("users").document(user.login).setData([
            "login" : user.login,
            "password" : user.password,
            "email" : user.email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
            }
        }
    }
    
    func checkUserLogin(givenEmail: String, givenPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: givenEmail, password: givenPassword) { (user, error) in
            if user != nil {
                completion(true)
                print("success")
            } else {
                completion(false)
                print("failed")
            }
            if let errorString = error?.localizedDescription {
                completion(false)
                print(errorString)
            }
            completion(false)
            
            
        }
        
        /*db.collection("users").document(givenEmail).getDocument { (document, error) in
            if let document = document, document.exists {
                if let login = document.get("login") as? String, let password = document.get("password") as? String {
                    if login == givenEmail, password == givenPassword {
                        print("login: \(login), password: \(password)")
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                print(error?.localizedDescription ?? "error")
                completion(false)
            }
        }*/
    }
    
    func getUserData(currentUserEmail: String, completion: @escaping (Array<String>) -> Void) {
        
        db.collection("users").document(currentUserEmail).collection("posts").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var postsArray: Array<String> = []
                for post in documents {
                    let postData = post.data()["text"] as! String
                    postsArray.append(postData)
                }
                completion(postsArray)
            }
            
        }
    }
    
}
