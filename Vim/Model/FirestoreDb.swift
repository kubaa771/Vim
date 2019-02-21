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
    
    func getPostsData(currentUser: User, completion: @escaping (Array<Post>) -> Void) {
        
        db.collection("users").document(currentUser.email).collection("posts").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var postsArray: Array<Post> = []
                for post in documents {
                    let myPost: Post!
                    let textContent = post.data()["text"] as! String
                    let timeResult = post.data()["date"] as! Timestamp
                    if let imageData = post.data()["image"] {
                        myPost = Post(date: timeResult, text: textContent, image: nil, imageData: (imageData as! NSData), owner: currentUser, id: UUID().uuidString)
                    } else {
                        myPost = Post(date: timeResult, text: textContent, image: nil, imageData: nil, owner: currentUser, id: UUID().uuidString)
                    }
                    postsArray.append(myPost)
                }
                completion(postsArray)
            }
        }
    }
    
    func createNewPost(currentUser: User, date: Timestamp, text: String, imageData: NSData?) {
        NotificationCenter.default.post(name: NotificationNames.refreshPostData.notification, object: nil)
        if let myimageData = imageData {
            db.collection("users").document(currentUser.email).collection("posts").addDocument(data: [
                "date" : date,
                "text" : text,
                "image" : myimageData
            ]) { (error) in
                if let errorString = error?.localizedDescription {
                    print(errorString)
                }
            }
        } else {
            db.collection("users").document(currentUser.email).collection("posts").addDocument(data: [
                "date" : date,
                "text" : text,
            ]) { (error) in
                if let errorString = error?.localizedDescription {
                    print(errorString)
                }
            }
        }
        
    }
    
    func getFriends(currentUser: User, completion: @escaping (Array<User>) -> Void) {
        db.collection("users").document(currentUser.email).collection("friends").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var friendsArray: Array<User> = []
                for friend in documents {
                    let friendEmail = friend.data()["email"] as! String
                    let friendUser = User(email: friendEmail, image: nil)
                    friendsArray.append(friendUser)
                }
                completion(friendsArray)
            }
        }
    }
    
}
