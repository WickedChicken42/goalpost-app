//
//  FinishGoalVC.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit
import CoreData

// Adding the UITextFieldDelegate protocol so that we can hanldle the TextField's events in the VC
class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var createGoalBtn: UIButton!
    @IBOutlet var pointsTxt: UITextField!
    
    var goalDesc: String!
    var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createGoalBtn.bindToKeyboard()

        // Setting the UITextField delegate to this VC so we can handle it's events
        pointsTxt.delegate = self
    }
    
    @IBAction func createGoalPressed(_ sender: Any) {
        
        // Check to make sure we have a point value before we attempt to save
        if pointsTxt.text != nil {
            // Call the saveToData funtion to perform the saving of the new goal to persistent storage
            self.saveToData { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }

        }
        
    }

    func initData(description: String, type: GoalType) {

        self.goalDesc = description
        self.goalType = type
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }

    func saveToData(completion: (_ finished: Bool) -> ()) {
    
        // Getting the Managed Context to work with the CoreData tools
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        // Creating the new goal data object as Goal data type from the managed context
        let newGoal = Goal(context: managedContext)
        
        // Setting the properties of the Goal data obejct
        newGoal.goalDescription = goalDesc
        newGoal.goalType = goalType.rawValue
        newGoal.goalCompletionValue = Int32(pointsTxt.text!)!
        newGoal.goalProgress = Int32(0)  // Intially setting it's value to 0 as we are the the start of the new goal

        // Using a Do/Try/Catch to make the final save call of the managed context to write the data to storage
        // Also setting the value of the completion handler based on our success in saving the data.
        do {
            try managedContext.save()
            print("Successfuly saved data!!")
            completion(true)
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
}
