//
//  LoginViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
          
            if error == nil{
                // User loggedin
                
                ServerCommunication.sharedDelegate.fetchUserData(userId: (authResult?.user.uid)!) { (status, message, user) in
                    if status{
                        // Assign user while login
                        User.userSharefReference = user!
                        print(authResult?.user.uid)
                        self?.navigationController?.setNavigationBarHidden(true, animated: true)
                        self?.performSegue(withIdentifier: "toDashboard", sender: nil)
                    }else{
                        self?.showAlert(controller: self!, title: "Failure", message: message, actiontitle: "Ok", completion: { (okButtonPressed) in
                            
                        })
                    }
                }
            }else{
                // Error
                print(error?.localizedDescription)
            }

        }
    }
    
    func setUpElements () {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginBtnOutlet)
    }

}
