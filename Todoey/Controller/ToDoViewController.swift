// VishalVerma865
//  ViewController.swift
//  To Do List

import UIKit
import CoreData
class ToDoViewController: UITableViewController {
    
   
 var itemArray = [Item]()
    var selectedCategory:Category? {
        didSet{
            loadItem()
            
        }
    }
   
    // Step 1 in view Controller access database container from appdelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                    
    
    
//_____________________________________________________________________________________________________________________________________________________
    
    override func viewDidLoad() {
  
        super.viewDidLoad()
        saveItem()
        tableView.reloadData()

    }
    
    
//_____________________________________________________________________________________________________________________________________________________

    
    @IBAction func addButtonList(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { [self] (action) in
            let newItem = Item(context: context)
            if textField.text != "" {

               newItem.title = textField.text!
            newItem.done = false
                newItem.parentcategory = self.selectedCategory
                print("this is the category \(selectedCategory!)")
        self.itemArray.append(newItem)
                saveItem()
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
    
//______________________________________________________________________________________________________________________________________________________

    
}
//MARK: - table view methods

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        if let itemTitle = item.title {
            cell.textLabel?.text = "\(itemTitle)"

        }
                //+++++++++++++++++ Note ++++++++++++++++++++++++++++++
                        // With Ternary Operator
        cell.accessoryType = item.done == true ? .checkmark : .none

      return cell
   }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
  
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
}

//MARK: - Save data and fetch data methods

extension ToDoViewController {
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error while save Item \(error)")
        }
    }
    func loadItem() {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
         let predicate = NSPredicate(format: "parentcategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        
        do {
         itemArray = try context.fetch(request)
            
        } catch {
            print("error while loading data \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar methods
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor( key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
         itemArray = try context.fetch(request)
            
        } catch {
            print("error while loading data \(error)")
        }
        tableView.reloadData()
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
