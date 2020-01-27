//
//  ProfileViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/13/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {

    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements ()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserProfile()
    }
    
    func setupUserProfile () {
        self.userName.text = User.userSharefReference.firstName
        self.emailTextField.text = User.userSharefReference.email
        self.phoneNumberTextField.text = User.userSharefReference.phoneNumber
        
        if let url = URL(string: User.userSharefReference.imageUrl) {
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                
            }
        }
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
    
    
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        User.userSharefReference = nil
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
}
    
    func setUpElements () {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneNumberTextField)
        Utilities.styleFilledButton(logOutBtn)
        Utilities.styleTextField(userName)
    }

}
