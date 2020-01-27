//
//  PublicTaskViewController.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/16/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit

class PublicTaskViewController: UIViewController {

    
    
    @IBOutlet weak var publicTaskTableView: UITableView!
    
        var tasks:Array = [Tasks]()
    
        var users:Array = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicTaskTableView.delegate = self
        publicTaskTableView.dataSource = self
        fetchAllTasks()

        // Do any additional setup after loading the view.
    }
    
        func fetchAllTasks(){
            ServerCommunication.sharedDelegate.fetchAllPublicTasks { (status, message, task, changeType) in
                if status{
                    switch changeType {
                    case .added:
                        self.addTask(task: task)
                    case .modified:
                        self.editTask(task: task)
                    case .removed:
                        self.removeTask(task: task)
                    }
                    self.publicTaskTableView.reloadData()
            }
        }
    }
    
    func addTask(task:Tasks){
        self.tasks.append(task)
    }
    
    func editTask(task:Tasks){
        if let indexOfOldTask = self.tasks.firstIndex(of: task){
            self.tasks[indexOfOldTask] = task
        }
    }
    
    func removeTask(task:Tasks){
        if let indexOfOldTask = self.tasks.firstIndex(of: task){
            self.tasks.remove(at: indexOfOldTask)
        }
    }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
    }

extension PublicTaskViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SharedTaskTableViewCell", owner: self, options: nil)?.first as! SharedTaskTableViewCell
        
        cell.tasksCellTitle.text = tasks[indexPath.row].title
        cell.tasksCellDescription.text = tasks[indexPath.row].description
        cell.tasksCellPriority.text = "\(tasks[indexPath.row].priority)"
       
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.showAlert(controller: self, title: "Delete Task", message: "Do you really want to delete this task?", actiontitle: "Delete") { (isDelete) in
                if isDelete{
                    ServerCommunication.sharedDelegate.deleteTask(id: self.tasks[indexPath.row].id) { (status, message) in
                        if status{
                            self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                                self.tasks.remove(at: indexPath.row)
                                self.publicTaskTableView.reloadData()
                            }
                        }else{
                            self.showAlert(controller: self, title: "Faile", message: message) { (ok) in
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

