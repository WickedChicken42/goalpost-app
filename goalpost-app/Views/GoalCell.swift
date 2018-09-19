//
//  GoalCell.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet var goalDescriptionLbl: UILabel!
    @IBOutlet var goalTypeLbl: UILabel!
    @IBOutlet var goalProgressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(description: String, type: GoalType, goalProgessAmount: Int) {
        
        self.goalDescriptionLbl.text = description
        self.goalTypeLbl.text = type.rawValue
        // Calling the description property on a number will return its string representation
        self.goalProgressLbl.text = goalProgessAmount.description
        
    }
    

}
