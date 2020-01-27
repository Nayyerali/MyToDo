//
//  Tasks.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/12/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import Foundation
import UIKit

struct Tasks:Comparable {
    
    var title: String
    var description:String
    var date:Date
    var priority:Int
    var id:String
    var isCompleted:Bool
    var userId:String
    var isPublic:Bool
    
    static func < (lhs: Tasks, rhs: Tasks) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.id == rhs.id
    }
}
