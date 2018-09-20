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
    @IBOutlet var completionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    // Configures the cell when cretaed based on the passed in values
    func configureCell(goal: Goal) {
        
        self.goalDescriptionLbl.text = goal.goalDescription
        self.goalTypeLbl.text = goal.goalType
        // Calling the description property on a number will return its string representation
        self.goalProgressLbl.text = goal.goalProgress.description
     
        if goal.goalProgress == goal.goalCompletionValue {
            self.completionView.isHidden = false
        } else {
            self.completionView.isHidden = true
        }
    }
    

}
