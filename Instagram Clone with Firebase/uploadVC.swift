//
//  SecondViewController.swift
//  Instagram Clone with Firebase
//
//  Created by Atıl Samancıoğlu on 17/12/2016.
//  Copyright © 2016 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButton: UIButton!

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
    
    }

    
    func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        self.uploadButton.isEnabled = false
        
        let mediaFolder = FIRStorage.storage().reference().child("media")
        if let data = UIImageJPEGRepresentation(postImage.image!, 0.5) {
            
            mediaFolder.child("\(uuid).jpg").put(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let post = ["image" : imageURL!, "postedby" : FIRAuth.auth()!.currentUser!.email!, "uuid" : self.uuid, "posttext" : self.postText.text] as [String : Any]
                    FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("posts").childByAutoId().setValue(post)
                    
                    self.postImage.image = UIImage(named: "tapmeImage.png")
                    self.postText.text = ""
                    self.uploadButton.isEnabled = true
                    self.tabBarController?.selectedIndex = 0
                    
                }
            })
            
        }
        
        
    }

}

