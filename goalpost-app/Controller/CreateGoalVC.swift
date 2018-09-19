//
//  CreateGoalVC.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet var goalTextView: UITextView!
    @IBOutlet var shortTermBtn: UIButton!
    @IBOutlet var longTermBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

    }


    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    
    @IBAction func shortTermButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logTermButtonPressed(_ sender: Any) {
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        // Using the new UIViewController extension method
        dismissDetail()
    }
    
}
