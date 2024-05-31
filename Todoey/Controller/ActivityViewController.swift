//
//  ActivityViewController.swift
//  Todoey
//
//  Created by Vishal Verma on 2021-06-14.
//

import UIKit
import CoreData
class ActivityViewController: UITableViewController {
    
    var activityArray = [Activity]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Activity", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Activity", style: .default) { [self] (action) in
            if textField.text != "" {
                let fieldInfo = Activity(context: context)
                fieldInfo.name = textField.text
                self.activityArray.append(fieldInfo)
                saveData()
                

tableView.reloadData()
                viewDidLoad()
            }

            else {

            present(alert, animated: true, completion: nil)
                textField.placeholder = "Enter Item to add"
           }
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
            
    
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "gotoCell", for: indexPath)
        cell.textLabel?.text = activityArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCategory", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedActivity = activityArray[indexPath.row]
            print(activityArray[indexPath.row])
            }
    
    }
    
    
    func saveData() {
        do {
    try  context.save()
    }
        catch{
            print("Error while Uploading data \(error)")
        }
    }
    func loadData() {
        var request:NSFetchRequest<Activity> = Activity.fetchRequest()
        do {
            activityArray = try context.fetch(request)
            
        }
        catch {
            print("Error While Getting data \(error)")
        }
    }
    
   

}

