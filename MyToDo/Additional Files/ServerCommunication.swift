//
//  ServerCommunication.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public class ServerCommunication{
    
    var firebaseFirestore:Firestore!
    var firebaseStorage:Storage!
    
    static var sharedDelegate = ServerCommunication()
    
    private init() {
        firebaseFirestore = Firestore.firestore()
        firebaseStorage = Storage.storage()
    }
    
    func addTask (title:String,desciption:String,priority:Int,isPublic:Bool,completion:@escaping(_ status:Bool,_ message:String)->Void) {
        let newTask = firebaseFirestore.collection("Tasks").document()
        
        newTask.setData(["Title": title, "Priority":priority, "Description":desciption, "Date":FieldValue.serverTimestamp(), "ID":newTask.documentID,"UserID":User.userSharefReference.userId,"isPublic":isPublic]) { (error) in
            if error == nil {
                // Success
                completion(true, "Task Is Added")
            } else {
                // Error
                completion(false, (error?.localizedDescription)!)
            }
        }
    }
    
    func fetchAllTasks (completion:@escaping(_ status:Bool, _ message:String,_ tasks:[Tasks]?)->Void){
        
        print (User.userSharefReference.userId)
        firebaseFirestore.collection("Tasks").whereField("UserID", isEqualTo: User.userSharefReference.userId).getDocuments { (snapshot, error) in
            if error == nil {
                // Success
                if let tasksDoc = snapshot?.documents{
                    // Got tasks
                    var tasks:Array = [Tasks]()
                    for documents in tasksDoc {
                        let taskData = documents.data()
                        let title = taskData["Title"] as! String
                        let priority = taskData["Priority"] as! Int
                        let description = taskData["Description"] as! String
                        let date = taskData["Date"] as! Timestamp
                        let id = taskData["ID"] as! String
                        let isPublic = taskData["isPublic"] as! Bool
                        
                        let task = Tasks(title: title, description: description, date: date.dateValue(), priority: priority, id: id, isCompleted: false, userId: User.userSharefReference.userId, isPublic: isPublic)
                        tasks.append(task)
                    }
                    completion(true, "Got Tasks", tasks)
                } else {
                    completion(false, error!.localizedDescription, nil)
                }
            }else{
            // failure
            completion(false,error!.localizedDescription,nil)
        }
    }
}
    func deleteTask (id:String,completion:@escaping(_ status:Bool, _ message:String)->Void) {
        
        firebaseFirestore.collection("Tasks").document(id).delete { (error) in
            if error == nil {
                // Task Deleted
                completion(true, "Task Is Deleted")
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    func uploadUserData (userData:[String:Any],completion:@escaping(_ status:Bool,_ message:String)->Void) {
        let userID = userData["UserID"] as! String
        firebaseFirestore.collection("Users").document(userID).setData(userData) { (error) in
            if error == nil {
                // Data is Uploaded
                completion(true, "User Data is Uploaded")
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    func fetchUserData (userId:String,completion:@escaping(_ status:Bool,_ message:String,_ user:User?)->Void) {
        
        firebaseFirestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                // You get Data
                if let userDictionary = snapshot.data() {
                    let user = User(userDict: userDictionary)
                    completion(true, "Got User Data", user)
                } else {
                    completion(false,"Unable to Get User Data", nil)
                }
                }else{
                    // You Get Error
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
    
    func uploadUserImage (image:UIImage,userId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
        // if status is true then downloadurl will be in response
        
        // Data in memory
        guard let data = image.jpegData(compressionQuality: 0.2) else {
            completion(false, "Unable to get data via URL")
            return
        }

        // Create a reference to the file you want to upload
        let riversRef = firebaseStorage.reference().child("images/\(userId).jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            completion(false,error!.localizedDescription)
            return
          }
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
                completion(false,error!.localizedDescription)
              return
            }
            completion(true,downloadURL.absoluteString)
            }
        }
    }
    
    func fetchAllPublicTasks(completion:@escaping(_ status:Bool, _ message:String,_ task:Tasks,_ actionType:DocumentChangeType)->Void){
        
        firebaseFirestore.collection("Tasks").whereField("isPublic", isEqualTo: true).addSnapshotListener { (snapshot, error) in
    
            if error == nil{
                
                
                if let documents = snapshot?.documentChanges{
                    
                    for docu in documents{
                        
                        let taskData = docu.document.data()
                        
                        let title = taskData["Title"] as! String
                        let description = taskData["Description"] as! String
                        let prority = taskData["Priority"] as! Int
                        let date = taskData["Date"] as! Timestamp
                        let id = taskData["ID"] as! String
                        let isPublic = taskData["isPublic"] as! Bool
                        
                        let task = Tasks(title: title, description: description, date: date.dateValue(), priority: prority, id: id, isCompleted: false, userId: User.userSharefReference.userId, isPublic: isPublic)
                        
                        completion(true,"",task,docu.type)
                    }
                }
     
            }else{
                // error
            }
        }
    }
}
