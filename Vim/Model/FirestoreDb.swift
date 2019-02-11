//
//  FirestoreDb.swift
//  Vim
//
//  Created by Jakub Iwaszek on 10/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreDb {
    
    static let shared = FirestoreDb()
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    
    init() {
        //docRef = Firestore.firestore().document("users")
    }
    
    func addNewUser(givenEmail: String, givenPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: givenEmail, password: givenPassword) { (user, error) in
            if user != nil {
                completion(true)
            } else {
                completion(false)
            }
            if let errorString = error?.localizedDescription {
                completion(false)
            }
        }
        /*db.collection("users").document(user.login).setData([
            "login" : user.login,
            "password" : user.password,
            "email" : user.email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
            }
        }*/
    }
    
    func checkUserLogin(givenEmail: String, givenPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: givenEmail, password: givenPassword) { (user, error) in
            if user != nil {
                completion(true)
            } else {
                completion(false)
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
    
    func getPostsData(currentUserEmail: String, completion: @escaping (Array<Post>) -> Void) {
        
        db.collection("users").document(currentUserEmail).collection("posts").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var postsArray: Array<Post> = []
                for post in documents {
                    let textContent = post.data()["text"] as! String
                    let timeResult = post.data()["date"] as! Timestamp
                    let myPost = Post(date: timeResult, text: textContent)
                    postsArray.append(myPost)
                }
                completion(postsArray)
            }
        }
    }
    
    func createNewPost(currentEmail: String, date: Timestamp, text: String) {
         db.collection("users").document(currentEmail).collection("posts").addDocument(data: [
            "date" : date,
            "text" : text
         ]) { (error) in
            if let errorString = error?.localizedDescription {
                print(errorString)
            }
        }
    }
    
}
