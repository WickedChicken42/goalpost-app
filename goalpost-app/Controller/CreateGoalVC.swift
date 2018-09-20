//
//  CreateGoalVC.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

// Adding the UITextViewDelegate protocol so that we can hanldle the TextView's events in the VC
class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet var goalTextView: UITextView!
    @IBOutlet var shortTermBtn: UIButton!
    @IBOutlet var longTermBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        // Binding the view to the keyboard via our Extension
        nextBtn.bindToKeyboard()
        
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        
        // Setting the UITextView delegate to this VC so we can handle it's events
        goalTextView.delegate = self
        
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if goalTextView.text != "" && goalTextView.text != "How many points until complete?" {

            // Creating a view controller from code via the Storyboard to move to
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC else { return }
            
            // Call the FinishGoalVC's initData function to send it the data it needs to have
            finishGoalVC.initData(description: goalTextView.text, type: goalType)
            
            // Using the new UIViewController extension method to show our instantiated VC
            presentingViewController?.presentSecondaryDetail(finishGoalVC)
            
        }

    }
    
    @IBAction func shortTermButtonPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()

    }
    
    @IBAction func logTermButtonPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermBtn.setDeselectedColor()
        longTermBtn.setSelectedColor()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        // Using the new UIViewController extension method
        dismissDetail()
    }
    
    // Handling the UITextView delegate event for when typing begins on the textfield
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
