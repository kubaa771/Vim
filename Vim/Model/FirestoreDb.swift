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
        
        db.collection("users").document(givenEmail).setData([
            "email" : givenEmail])
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
                let group = DispatchGroup()
                for friend in documents {
                    group.enter()
                    let friendEmail = friend.data()["email"] as! String
                    self.getUserProfileData(email: friendEmail, completion: { (friendUser) in
                        friendsArray.append(friendUser)
                        group.leave()
                    })
                }
                //group.wait()
                //completion(friendsArray)
                
                group.notify(queue: .main) {
                    completion(friendsArray)
                }
            }
        }
    }
    
    func getAllUsers(completion: @escaping (Array<User>) -> Void) {
        db.collection("users").getDocuments { (snapshot, err) in
            if let documents = snapshot?.documents {
                var usersArray: Array<User> = []
                let group = DispatchGroup()
                for user in documents {
                    group.enter()
                    let userEmail = user.data()["email"] as! String
                    self.getUserProfileData(email: userEmail, completion: { (newUser) in
                        usersArray.append(newUser)
                        group.leave()
                    })
                }
                group.notify(queue: .main) {
                    completion(usersArray)
                }
            }
        }
    }
    
    func addFriend(currentUser: User, userToAdd: User) {
        NotificationCenter.default.post(name: NotificationNames.refreshPostData.notification, object: nil)
        db.collection("users").document(currentUser.email).collection("friends").addDocument(data: [
            "email" : userToAdd.email])
    }
    
    func getUserProfileData(email: String, completion: @escaping (User) -> Void){
        
        db.collection("users").document(email).getDocument { (snapshot, error) in
            if let documentData = snapshot?.data(){
                let email = documentData["email"] as! String
                let name: String
                let surname: String
                let photo: NSData?
                
                if let nameData = documentData["name"] as? String {
                    name = nameData
                } else {
                    name = " "
                }
                if let surnameData = documentData["surname"] as? String {
                    surname = surnameData
                } else {
                    surname = " "
                }
                if let photoData = documentData["photo"] as? NSData {
                    photo = photoData
                } else {
                    photo = nil
                }
                
                let user = User(email: email, imageData: photo, name: name, surname: surname, id: UUID().uuidString)
                completion(user)
            }
           
        }
    }
    
    func updateUserProfile(auth: Auth, newUser: User, newPassword: String?, completion: @escaping (Bool) -> Void) {
        NotificationCenter.default.post(name: NotificationNames.refreshProfile.notification, object: nil)
        if let name = newUser.name {
            db.collection("users").document(newUser.email).updateData(["name" : name])
        }
        
        if let surname = newUser.surname {
            db.collection("users").document(newUser.email).updateData(["surname" : surname])
        }
        
        if let photo = newUser.imageData {
            db.collection("users").document(newUser.email).updateData(["photo" : photo])
        }
        
        let user = auth.currentUser
        if let user = user {
            if let password = newPassword {
                user.updatePassword(to: password) { (error) in
                    completion(false)
                }
            }
        }
        completion(true)
    }
    
}
