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
                user?.user.createProfileChangeRequest().commitChanges(completion: { (error) in
                })
                self.db.collection("users").document((user?.user.uid)!).setData([
                    "email" : givenEmail,
                    "name" : givenName])
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
            
            
        }
    
    }
    
    func getPostsData(currentUser: User, completion: @escaping (Array<Post>) -> Void) {
        db.collection("users").document(currentUser.uuid).collection("posts").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var postsArray: Array<Post> = []
                let group = DispatchGroup()
                for post in documents {
                    group.enter()
                    var myPost: Post!
                    let textContent = post.data()["text"] as! String
                    let timeResult = post.data()["date"] as! Timestamp
                    let imageData = post.data()["image"] as? NSData
                    /*var peopleWhoLikedIDs: Array<String> = []
                    let group = DispatchGroup()
                    
                    group.enter()
                    post.reference.collection("peopleWhoLiked").getDocuments(completion: { (snapshot, err) in
                        if let documents = snapshot?.documents {
                            for document in documents {
                                
                                peopleWhoLikedIDs.append(document.data()["uuid"] as! String)
                                group.leave()
                            }
                        } else {
                            print("cops")
                        }
                    })
                    group.notify(queue: .main, execute: {
                        print(peopleWhoLikedIDs)
                    })*/
                    
                    post.reference.collection("peopleWhoLiked").getDocuments(completion: { (snapshot, error) in
                        if let documents = snapshot?.documents {
                            let likes = documents.map { $0["uuid"] } as? Array<String>
                            myPost = Post(date: timeResult, text: textContent, image: nil, imageData: imageData, owner: currentUser, id: post.documentID, whoLiked: likes)
                            postsArray.append(myPost)
                            group.leave()
                        }
                    })
                    
                }
                group.notify(queue: .main, execute: {
                    completion(postsArray)
                })
            }
        }
    }
    
    func createNewPost(date: Timestamp, text: String, imageData: NSData?) {
        NotificationCenter.default.post(name: NotificationNames.refreshPostData.notification, object: nil)
        let userID = Auth.auth().currentUser!.uid
        if let myimageData = imageData {
            db.collection("users").document(userID).collection("posts").addDocument(data: [
                "date" : date,
                "text" : text,
                "image" : myimageData
            ]) { (error) in
                if let errorString = error?.localizedDescription {
                    print(errorString)
                }
            }
        } else {
            db.collection("users").document(userID).collection("posts").addDocument(data: [
                "date" : date,
                "text" : text,
            ]) { (error) in
                if let errorString = error?.localizedDescription {
                    print(errorString)
                }
            }
        }
        
    }
    
    func getFriends(completion: @escaping (Array<User>) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("friends").getDocuments { (snapshot, error) in
            if let documents = snapshot?.documents {
                var friendsArray: Array<User> = []
                let group = DispatchGroup()
                for friend in documents {
                    group.enter()
                    let friendEmail = friend.data()["email"] as! String
                    let friendID = friend.data()["id"] as! String
                    self.getUserProfileData(userID: friendID, completion: { (friendUser) in
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
                    let userID = user.documentID
                    print(userID)
                    self.getUserProfileData(userID: userID, completion: { (newUser) in
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
    
    func addFriend(userToAdd: User) {
        //NotificationCenter.default.post(name: NotificationNames.refreshPostData.notification, object: nil)
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("friends").addDocument(data: [
            "email" : userToAdd.email!,
            "id" : userToAdd.uuid])
    }
    
    func getUserProfileData(userID: String, completion: @escaping (User) -> Void){
        db.collection("users").document(userID).getDocument { (snapshot, error) in
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
                
                let user = User(email: email, imageData: photo, name: name, surname: surname, id: userID)
                completion(user)
            }
           
        }
    }
    
    func updateUserProfile(auth: Auth, newUser: User, newPassword: String?, completion: @escaping (Bool) -> Void) {
        NotificationCenter.default.post(name: NotificationNames.refreshProfile.notification, object: nil)
        if let name = newUser.name {
            db.collection("users").document(newUser.uuid).updateData(["name" : name])
        }
        
        if let surname = newUser.surname {
            db.collection("users").document(newUser.uuid).updateData(["surname" : surname])
        }
        
        if let photo = newUser.imageData {
            db.collection("users").document(newUser.uuid).updateData(["photo" : photo])
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
    
    func likedAPost(whoLiked: User, likedPost: Post, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(likedPost.owner.uuid).collection("posts").document(likedPost.uuid).collection("peopleWhoLiked").document(whoLiked.uuid).setData(["uuid" : whoLiked.uuid])
        completion(true)
    }
    
}
