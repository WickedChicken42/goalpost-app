//
//  MemoryGoal.swift
//  goalpost-app
//
//  Created by James Ullom on 9/20/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

struct MemoryGoal {
    var description: String
    var goalType: GoalType
    var duration: Int32
    var progress: Int32
    
    init(dataGoal: Goal) {
    
        description = dataGoal.goalDescription!
        goalType = GoalType(rawValue: dataGoal.goalType!)!
        duration = dataGoal.goalCompletionValue
        progress = dataGoal.goalProgress
    }
    
    func loadDataGoal(dataGoal: Goal) {

        dataGoal.goalDescription = description
        dataGoal.goalType = goalType.rawValue
        dataGoal.goalCompletionValue = duration
        dataGoal.goalProgress = progress

    }
}
