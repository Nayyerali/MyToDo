//
//  TasksTableViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol AddTaskDelegate {
    func addTask()
}

class TasksTableViewController: UIViewController, AddTaskDelegate {
    
    var tasksArray:Array = [Tasks]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fetchUserData(){
        if User.userSharefReference == nil {
            if let user = Auth.auth().currentUser{
                ServerCommunication.sharedDelegate.fetchUserData(userId: user.uid) { (status, message, user) in
                    if status {
                        User.userSharefReference = user!
                        self.fetchAllTasks()
                    } else{
                        self.showAlert(controller: self, title: "Failure", message: message, actiontitle: "Ok") { (okButtonPressed) in
                            // handle this
                        }
                    }
                }
            }
        }
    }
    
    func addTask() {
        
        self.fetchAllTasks()
    }
    
    func fetchAllTasks() {
        
        ServerCommunication.sharedDelegate.fetchAllTasks { (status, message, tasks) in
            if status{
                // success
                self.tasksArray.removeAll()
                self.tasksArray = tasks!
                self.tasksArray.sort()
                self.tableView.reloadData()
            }else{
                // failure
                self.showAlert(controller: self, title: "Failure", message: message) { (ok) in
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    @IBAction func addTaskBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "TasksCell", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TasksCell" {
            let destination = segue.destination as! AddTaskViewController
            destination.addTaskProtocol = self
        }
    }
}

extension TasksTableViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SharedTaskTableViewCell", owner: self, options: nil)?.first as! SharedTaskTableViewCell
        
        cell.tasksCellTitle.text = tasksArray[indexPath.row].title
        cell.tasksCellPriority.text = "\(tasksArray[indexPath.row].priority)"
        cell.tasksCellDescription.text = tasksArray[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showAlert(controller: self, title: "Delete Tasks", message: "Do You Really Wanna Delete This Tasks ?", actiontitle: "Delete") { (isDeleted) in
                if isDeleted {
                    ServerCommunication.sharedDelegate.deleteTask(id: self.tasksArray[indexPath.row].id) { (status, message) in
                        if status {
                            self.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                                self.tasksArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                            }
                        } else {
                            self.showAlert(controller: self, title: "Failed to Delete Task", message: message) { (ok) in
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
