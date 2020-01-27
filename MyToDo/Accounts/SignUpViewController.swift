//
//  SignUpViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var birthPlace: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        addGesture()
        // Do any additional setup after loading the view.
    }
    
    func addGesture () {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
    }
    
    @objc func userImageTapped () {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (Ok) in
            // Camera Option Tapped
            self.presentImagePicker(type: .camera)
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (Gallery) in
            // Gallery Option Tapped
            self.presentImagePicker(type: .photoLibrary)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style: .destructive) { (Cancle) in
            // Cancle Option tapped
        }
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(galleryAction)
            actionSheet.addAction(cancleAction)
        
            self.present(actionSheet, animated: true, completion: nil)
    }
    
    func presentImagePicker (type:UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if error == nil {
                // User Created Succesfully
                print (authResult?.user.uid)
                
                ServerCommunication.sharedDelegate.uploadUserImage(image: self.userImage.image!, userId: (authResult?.user.uid)!) { (status, response) in
                    if status {
                        // Image Uploaded

                        let newUser = User(firstName: self.firstName.text!, lastName: self.lastName.text!, dateOfBirth: self.dateOfBirth.text!, birthPlace: self.birthPlace.text!, phoneNumber: self.phoneNumber.text!, email: self.email.text!, password: self.password.text!, confirmPassword: self.confirmPassword.text!, userId: (authResult?.user.uid)!, imageUrl: response)
                        
                        // Assign current user while creating account
                        
                        User.userSharefReference = newUser
                        
                        ServerCommunication.sharedDelegate.uploadUserData(userData: newUser.getUserDict()) { (status, message) in

                            if status {
                                // move to homescreen
                                self.navigationController?.setNavigationBarHidden(true, animated: false)
                                self.performSegue(withIdentifier: "toDashboard", sender: nil)
                            } else {
                                self.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                                    // ok button pressed
                                }
                            }
                        }
                    } else {
                        // Unable to upload image
                        self.showAlert(controller: self, title: "Error", message: response) { (ok) in
                            // Ok button pressed
                        }
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    func setUpElements (){
        
        Utilities.styleFilledButton(signUpBtnOutlet)
        Utilities.styleTextField(firstName)
        Utilities.styleTextField(lastName)
        Utilities.styleTextField(dateOfBirth)
        Utilities.styleTextField(birthPlace)
        Utilities.styleTextField(email)
        Utilities.styleTextField(phoneNumber)
        Utilities.styleTextField(password)
        Utilities.styleTextField(confirmPassword)
    }
}

extension SignUpViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.userImage.image = pickedImage
        self.dismiss(animated: true, completion: nil)
    }
}
