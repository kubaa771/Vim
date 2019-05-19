//
//  AddNewPostViewController.swift
//  Vim
//
//  Created by Jakub Iwaszek on 15/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AddNewPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var imageView: UIImageView! 
    
    var typedText: String?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = "What's on your mind?"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        
        else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        typedText = textView.text
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
    
    @IBAction func removePhoto(_ sender: UIButton) {
        imageView.image = nil
        minusButton.isHidden = true
    }
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        selectImageFrom(.camera)
    }
    
    
    @IBAction func openPicturesTapped(_ sender: UIButton) {
        selectImageFrom(.photoLibrary)
    }
    
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        if typedText != nil {
            if let image = imageView.image {
                let imageData = NSData(data: (image.jpegData(compressionQuality: 0.1))!)
                FirestoreDb.shared.createNewPost(date: Firebase.Timestamp.init(date: Date()), text: typedText!, imageData: imageData)
            } else {
                FirestoreDb.shared.createNewPost(date: Firebase.Timestamp.init(date: Date()), text: typedText!, imageData: nil)
            }
            navigationController?.popViewController(animated: true)
        } else {
            self.displayErrorAlert(message: "You should type something!")
        }
    }
    
}

extension AddNewPostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        minusButton.isHidden = false
        imageView.image = selectedImage
    }
}


