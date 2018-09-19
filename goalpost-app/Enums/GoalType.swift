//
//  GoalType.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import Foundation

// Defining thre enum with a specific type so that we can pull out the raw value when displasying to saving to the DB
enum GoalType: String {
    case longTerm = "Long Term"
    case shortTerm = "Short Term"
}
