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
    
    // Creating an empty array of type Goal to be loaded from persisten storage
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        // Forcing the show of the table view while developing the UI
        tableView.isHidden = false
        
        // Added to support the tableview functionality
        tableView.delegate = self
        tableView.dataSource = self
    }

    // We fetch the data in persistent storage on this VC event and regardless of the amount of data returned reload the tableview
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetch { (complete) in
            if complete {
                // If we have any data returned, show/hide the tableview
                if goals.count > 0 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
        
        tableView.reloadData()
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

        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating a cell of data while developing
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }

        let goal = goals[indexPath.row]

        cell.configureCell(description: goal.goalDescription!, type: GoalType(rawValue: goal.goalType!)!, goalProgessAmount: Int(goal.goalProgress))
        
        return cell

    }
    
}

// Creating this extension to define the fetch function that will pull our goals from persistent storage
extension GoalsVC {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        
        // Get the managed context for this app
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
       
        // Define the request we are making as a type Goal using the entity name "Goal" from the data model
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            // Loading the goals array with the data retreived from storage
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
            
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
}
