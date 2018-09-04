//
//  MealTableViewController.swift
//  Food
//
//  Created by Gouthami Reddy on 8/18/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
     loadSampleMeals()
    }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as? MealTableViewCell else {
     fatalError("the deqeue cell is not an instance of MealTableViewCell")
    }
        let meal = meals[indexPath.row]
        
     cell.nameLbl.text = meal.name
       cell.imageview.image = meal.photo
        cell.ratingLbl.rating = meal.rating
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("adding a new meal", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? ViewController
                else {
                    fatalError("unexpected destination: \(segue.destination)")
            }
            guard let selelctedMealCell = sender as? MealTableViewCell
                else {
                    fatalError("unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selelctedMealCell) else {
                fatalError("the selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("unexpected segue identifier; \(segue.identifier)")
        }
        
    }
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as?
            ViewController, let meal = sourceViewController.meal {
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else  {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveMeals()
        }
    }
   

    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "yummy burger", photo: photo1, rating: 4) else {
            fatalError("unnable to instantiate burger")
        }
        guard let meal2 = Meal(name: "Large pizza", photo: photo2, rating: 3) else {
            fatalError("unable to instantiate pizza")
        }
        guard let meal3 = Meal(name: "spicy pasta", photo: photo3, rating: 5) else {
            fatalError("unable to instantiate pasta")
        }
        meals +=  [meal1,meal2,meal3]
    }
   
  
    private func saveMeals() {
      let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Meals", log: OSLog.default, type: .error)
        }
}
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}
