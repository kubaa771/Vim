//
//  EditProfileViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 03/03/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    var newName: String?
    var newSurname: String?
    var newPassword: String?
    var defaultImage = UIImage(named: "user_male.jpg")
    
    @IBOutlet weak var profileImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = defaultImage
        // Do any additional setup after loading the view.
    }
    

    @IBAction func nameTextFieldEdit(_ sender: UITextField) {
        newName = sender.text
    }
    
    @IBAction func surnameTextFieldEdit(_ sender: UITextField) {
        newSurname = sender.text
    }
    
    @IBAction func passwordTextFieldEdit(_ sender: UITextField) {
        newPassword = sender.text
    }
    
    
    @IBAction func chooseFromGalleryAction(_ sender: UIButton) {
         selectImageFrom(.photoLibrary)
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
         selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        if newName == nil, newSurname == nil, newPassword == nil, profileImageView.image == nil {
            displayErrorAlert(message: "Fulfill any field!")
        } else {
            let image = profileImageView.image
            var imageData: NSData?
            if profileImageView.image == defaultImage {
                imageData = nil
            } else {
                imageData = NSData(data: (image?.jpegData(compressionQuality: 0.1))!)
            }
            let user = User(email: auth.currentUser?.email, imageData: imageData, name: newName, surname: newSurname, id: UUID().uuidString)
            FirestoreDb.shared.updateUserProfile(auth: auth, newUser: user, newPassword: newPassword) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.displayErrorAlert(message: "Something went wrong. Try again later!")
                }
            }
        }
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

extension EditProfileViewController :UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        //minusButton.isHidden = false
        profileImageView.image = selectedImage
    }
}
