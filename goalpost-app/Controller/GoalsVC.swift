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
        
        fetchCoreDataObjects()
        
        tableView.reloadData()
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {

        // Creating a view controller from code via the Storyboard to move to
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }

        // Using the new UIViewController extension method to show our instantiated VC
        presentDetail(createGoalVC)
        
    }

    func fetchCoreDataObjects() {
        
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
 
    // Added to support the swiping of row items to access their Actions - Allows editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Added to support the swiping of row items to access their Actions - Won't show any special icons
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // Added to support the swiping of row items to access their Actions - Defining the actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // Define the Delete action shown when swiping on a row item
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            // What we will do when the Delete action is pressed (or full swiped)
            // Removes the goal from persistent storage
            self.removeGoal(atIndexPath: indexPath)
            // Reload the local goals array from persisten storage
            self.fetchCoreDataObjects()
            // Remove the deleted goal from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

        var actions: [UITableViewRowAction] = []
        actions.append(deleteAction)

        return actions
    }
}

// Creating this extension to define the fetch function that will pull our goals from persistent storage
extension GoalsVC {
    
    // Retreives the data from persisten storage and loads them to the local goals array
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
    
    // Used to remove a specific goal from our data based on the indexPath being passed in
    func removeGoal(atIndexPath: IndexPath) {
        
        // Get the managed context for this app
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // Delete the item from our managed context
        managedContext.delete(goals[atIndexPath.row])
        
        // Perform a Do/Try/Catch to save the context which will remove the deleted item from storage
        do {
            try managedContext.save()
            print("Successfully deleted a goal!")
        } catch {
            debugPrint("Could not delete a goal: \(error.localizedDescription)")
        }
    }

}
