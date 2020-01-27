//
//  ViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/10/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var loginBtnOut: UIButton!
    
    @IBOutlet weak var signUpBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements () {
        
        Utilities.styleFilledButton(signUpBtnOut)
        Utilities.styleHollowButton(loginBtnOut)
    }

}

