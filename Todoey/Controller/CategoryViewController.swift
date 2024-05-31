//
//  CCategoryViewController.swift
//  Todoey
//
//  Created by Vishal Verma on 2021-06-11.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    var selectedActivity:Activity?{
        didSet{
            loadDataFromCore()
        }
    
    }
        var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadDataFromCore()

        }
        
        
        //MARK: - add button
        
        @IBAction func addButton(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { [self] (action) in
                if textField.text != "" {
                    let newCategory = Category(context: context)
                    newCategory.name = textField.text
                    newCategory.parentactivity = selectedActivity
            self.categoryArray.append(newCategory)
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
        

     
        
    }


    //MARK: - tableview Data Source
    extension CategoryViewController {
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return categoryArray.count
        
    }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell1", for: indexPath)
            cell.textLabel?.text = categoryArray[indexPath.row].name
            return cell
        }
        
        //MARK: - tableView Delegate
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: "goToItem", sender: self)
            
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! ToDoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                var gem =  categoryArray[indexPath.row]
                destinationVC.selectedCategory = gem
        }
        }
    }



    //MARK: - data manuplation
    extension CategoryViewController {
        
        func saveData() {
            do {
           try context.save()
            } catch {
                print("Error while uploading data \(error)")
            }
        }
        
        
        
        func loadDataFromCore() {
            
            let request:NSFetchRequest<Category> = Category.fetchRequest()
            let predicate = NSPredicate(format: "parentactivity.name MATCHES %@", selectedActivity!.name!)
            request.predicate = predicate
            do {
                categoryArray = try context.fetch(request)
                
            } catch {
                print("Error while loading data from core \(error)")
            }
        }
        
        
        
        
    }

