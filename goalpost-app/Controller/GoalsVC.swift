//
//  GoalsVC.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        // Forcing the show of the table view while developing the UI
        tableView.isHidden = false
        
        // Added to support the tableview functionality
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func addGoalBtnPressed(_ sender: Any) {

        // Creating a view controller from code via the Storyboard to move to
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }

        // Using the new UIViewController extension method to show our instantiated VC
        presentDetail(createGoalVC)
        
    }
    
}

// Creating an extention of this VC to support the tableview implementation requirements - I LIKE THIS MUCH!!!
extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Foring a value of three while developing the UI
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating a cell of data while developing
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        cell.configureCell(description: "Eat salad twice a week", type: .shortTerm, goalProgessAmount: 2)
        return cell

    }
}
