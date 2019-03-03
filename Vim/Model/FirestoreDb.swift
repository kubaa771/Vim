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
    
    func addNewUser(givenEmail: String, givenPassword: String, givenName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: givenEmail, password: givenPassword) { (user, error) in
            if user != nil {
                user?.user.createProfileChangeRequest().displayName = givenName
                user?.user.createProfileChangeRequest().commitChanges(completion: { (error) in
                })
                completion(true)
            } else {
                completion(false)
            }
            if let errorString = error?.localizedDescription {
                completion(false)
            }
        }
        
        db.collection("users").document(givenEmail).setData(["email" : givenEmail])
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
                    let friendUser = User(email: friendEmail, image: nil, name: nil, surname: nil, id: UUID().uuidString)
                    friendsArray.append(friendUser)
                }
                completion(friendsArray)
            }
        }
    }
    
    func getAllUsers(completion: @escaping (Array<User>) -> Void) {
        db.collection("users").getDocuments { (snapshot, err) in
            if let documents = snapshot?.documents {
                var usersArray: Array<User> = []
                for document in documents {
                    let emailData = document.data()["email"] as! String
                    let user = User(email: emailData, image: nil, name: nil, surname: nil, id: UUID().uuidString)
                    usersArray.append(user)
                }
                completion(usersArray)
            }
        }
    }
    
    func addFriend(currentUser: User, userToAdd: User) {
        NotificationCenter.default.post(name: NotificationNames.refreshPostData.notification, object: nil)
        db.collection("users").document(currentUser.email).collection("friends").addDocument(data: [
            "email" : userToAdd.email])
    }
    
    func getUserProfileData(email: String, completion: @escaping (User) -> Void) {
        db.collection("users").document(email).getDocument { (snapshot, error) in
            if let documentData = snapshot?.data(){
                let email = documentData["email"] as! String
                guard let name = documentData["name"] as? String else {
                    return
                }
                guard let surname = documentData["surname"] as? String else {
                    return
                }
                guard let photo = documentData["photo"] as? NSData else {
                    return
                }
                guard let id = documentData["id"] as? String else {
                    return
                }
                let user = User(email: email, image: photo, name: name, surname: surname, id: id)
                completion(user)
            }
           
        }
    }
    
    func updateUserProfile(auth: Auth, newName: String?, newPassword: String?, completion: @escaping (Bool) -> Void) {
        let user = auth.currentUser
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        if let user = user {
            var i = 0
            
            if let name = newName {
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (error) in
                    completion(false)
                })
                i += 1
            }
            
            if let password = newPassword {
                user.updatePassword(to: password) { (error) in
                    completion(false)
                }
                i += 1
            }
            
            if i == 2 {
                i=0
                completion(true)
            } else if i == 1 {
                i=0
                completion(true)
            } else if i == 0 {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
}
