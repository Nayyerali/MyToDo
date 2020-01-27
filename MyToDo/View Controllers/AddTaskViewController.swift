//
//  AddTaskViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTasksTitle: UITextField!
    
    @IBOutlet weak var addTasksPriority: UITextField!
    
    @IBOutlet weak var addTaskDescription: UITextField!
    
    @IBOutlet weak var addTaskBtn: UIButton!
    
    @IBOutlet weak var isPublicSwitch: UISwitch!
    
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    var addTaskProtocol : AddTaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addTaskBtn(_ sender: Any) {
        
        ServerCommunication.sharedDelegate.addTask(title: addTasksTitle.text!, desciption: addTaskDescription.text!, priority: Int(addTasksPriority.text!)!,isPublic: isPublicSwitch.isOn) { (status, message) in
            if status {
                // Data is Added
                self.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                    self.addTaskProtocol?.addTask()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                // Error
                self.showAlert(controller: self, title: "Faliure", message: message) { (Ok) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func setUpElements () {
        Utilities.styleFilledButton(addTaskBtn)
        Utilities.styleTextField(addTasksTitle)
        Utilities.styleTextField(addTasksPriority)
        Utilities.styleTextField(addTaskDescription)
    }
}


extension UIViewController {
    
        func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
            let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
                // ok button press
                completion(true)
            }
            alerController.addAction(okAction)
            controller.present(alerController, animated: true)
        }
        
        func showAlert(controller:UIViewController,title:String,message:String,actiontitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
            let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let delete = UIAlertAction(title: actiontitle, style: .destructive) { (alertAction) in
                // ok button press
                completion(true)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
                // ok button press
                completion(false)
            }
            alerController.addAction(delete)
            alerController.addAction(cancel)
            controller.present(alerController, animated: true)
        }
    }
