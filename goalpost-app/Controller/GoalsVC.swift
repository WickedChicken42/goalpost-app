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
    @IBOutlet var completionView: UIView!
    @IBOutlet var undoRemoveView: UIView!
    
    // Creating an empty array of type Goal to be loaded from persisten storage
    var goals: [Goal] = []
    var lastDeletedGoal: MemoryGoal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        // Forcing the show of the table view while developing the UI
        //tableView.isHidden = false
        undoRemoveView.isHidden = true
        
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

    // Retreives the data from persistent storage and sets if the table view is hidden
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
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        
        // Make sure we have a undo goal to put back
        guard let deletedGoal = self.lastDeletedGoal else {return}

        undoGoal(memoryGoal: deletedGoal)
        
        fetchCoreDataObjects()
        
        tableView.reloadData()
        
        undoRemoveView.isHidden = true
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

        cell.configureCell(goal: goal)
        
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

            // Hold onto the deleted goal item
            self.lastDeletedGoal = MemoryGoal(dataGoal: self.goals[indexPath.row])
            
            // Removes the goal from persistent storage
            self.removeGoal(atIndexPath: indexPath)
            
            // Reload the local goals array from persisten storage
            self.fetchCoreDataObjects()

            // Remove the deleted goal from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)

            // Show the undo view
            self.undoRemoveView.isHidden = false
        }

        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

        var actions: [UITableViewRowAction] = []
        actions.append(deleteAction)
        
        // Define an "Add 1" action to increment the goal progress from the tableview swipe
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            // What we will do when the ADD 1 action is pressed

            // Increment the goal progress value
            self.setProgress(atIndexPath: indexPath)

            // Reload the affected row in the tableview
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        addAction.backgroundColor = #colorLiteral(red: 0.9513939023, green: 0.7167944312, blue: 0.3330523372, alpha: 1)
        actions.append(addAction)

        return actions
        // Alternative way to return the action array
        // return [deleteAction, addAction]
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

    // Increments the goal's progress if it isn't complete
    func setProgress(atIndexPath: IndexPath) {

        // Get the managed context for this app
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        // Get the goal item based on the passed in indexPath
        let selectedGoal = goals[atIndexPath.row]
        
        // If we have not met our goal then increment it by 1
        if selectedGoal.goalProgress < selectedGoal.goalCompletionValue {
            selectedGoal.goalProgress += 1

            // Save the updated progress
            do {
                try managedContext.save()
                print("Successly saved progress!")
            } catch {
                debugPrint("Could not set progress: \(error.localizedDescription)")
            }
        }
        
    }
    
    // Used to re-insert a previously deleted goal
    func undoGoal(memoryGoal: MemoryGoal) {
        
        // Get the managed context for this app
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let newGoal = Goal(context: managedContext)
        memoryGoal.loadDataGoal(dataGoal: newGoal)
        
        // Delete the item from our managed context
        managedContext.insert(newGoal)
        
        // Perform a Do/Try/Catch to save the context which will remove the deleted item from storage
        do {
            try managedContext.save()
            self.lastDeletedGoal = nil
            print("Successfully inserted a goal!")
        } catch {
            debugPrint("Could not insert a goal: \(error.localizedDescription)")
        }
    }

}
