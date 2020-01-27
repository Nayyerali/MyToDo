//
//  User.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct User {
    
    static var userSharefReference:User!
    
    var firstName:String
    var lastName:String
    var dateOfBirth:String
    var birthPlace:String
    var phoneNumber:String
    var email:String
    var password:String
    var confirmPassword:String
    var userId:String
    var imageUrl:String
    
    enum FirebaseKeys:String {
        case FirstName = "First Name"
        case LastName = "LastName"
        case ImageURL = "ImageURL"
        case DateOfBirth = "DateOfBirth"
        case BirthPlace = "BirthPlace"
        case PhoneNumber = "PhoneNumber"
        case Email = "Email"
        case Password = "Password"
        case ConfirmPassword = "ConfirmPassword"
        case UserID = "UserID"
    }
    
    init (userDict:[String:Any]) {
        self.firstName = userDict[FirebaseKeys.FirstName.rawValue] as! String
        self.lastName = userDict[FirebaseKeys.LastName.rawValue] as! String
        self.dateOfBirth = userDict[FirebaseKeys.DateOfBirth.rawValue] as! String
        self.birthPlace = userDict[FirebaseKeys.BirthPlace.rawValue] as! String
        self.phoneNumber = userDict[FirebaseKeys.PhoneNumber.rawValue] as! String
        self.email = userDict[FirebaseKeys.Email.rawValue] as! String
        self.password = userDict[FirebaseKeys.Password.rawValue] as! String
        self.confirmPassword = userDict[FirebaseKeys.ConfirmPassword.rawValue] as! String
        self.userId = userDict[FirebaseKeys.UserID.rawValue] as! String
        self.imageUrl = userDict[FirebaseKeys.ImageURL.rawValue] as! String
    }
    
    init (firstName:String,lastName:String,dateOfBirth:String,birthPlace:String,phoneNumber:String,email:String,password:String,confirmPassword:String,userId:String,imageUrl:String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.birthPlace = birthPlace
        self.phoneNumber = phoneNumber
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.userId = userId
        self.imageUrl = imageUrl
        
    }
    
    func getUserDict()->[String:Any] {
    return [
        FirebaseKeys.FirstName.rawValue:self.firstName,
        FirebaseKeys.LastName.rawValue:self.lastName,
        FirebaseKeys.DateOfBirth.rawValue:self.dateOfBirth,
        FirebaseKeys.BirthPlace.rawValue:self.birthPlace,
        FirebaseKeys.PhoneNumber.rawValue:self.phoneNumber,
        FirebaseKeys.Email.rawValue:self.email,
        FirebaseKeys.Password.rawValue:self.password,
        FirebaseKeys.ConfirmPassword.rawValue:self.confirmPassword,
        FirebaseKeys.UserID.rawValue:self.userId,
        FirebaseKeys.ImageURL.rawValue:self.imageUrl
        ]
    }
}
