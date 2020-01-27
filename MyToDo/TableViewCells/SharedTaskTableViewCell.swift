//
//  SharedTaskTableViewCell.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/16/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit

class SharedTaskTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tasksCellTitle: UILabel!
    
    @IBOutlet weak var tasksCellDate: UILabel!
    
    @IBOutlet weak var tasksCellPriority: UILabel!
    
    @IBOutlet weak var tasksCellDescription: UITextView!
    
    @IBOutlet weak var isCompleted: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
