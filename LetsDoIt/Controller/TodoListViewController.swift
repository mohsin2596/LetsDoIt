//
//  ViewController.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/16/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        if let item = itemArray?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
   
        }
        else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                    self.tableView.reloadData()
                }
            }
            catch {
                print("Error writing to realm: \(error)")
            }
        }

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add button function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var gTextField = UITextField()
        
        let alert = UIAlertController(title: "Lets add something to the list", message: "", preferredStyle: .alert)
        
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let itemString = gTextField.text, !gTextField.text!.isEmpty {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = itemString
                            newItem.date = Date()
                            currentCategory.items.append(newItem)
                            self.realm.add(newItem)
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    catch {
                        print("Error writing to realm: \(error)")
                    }
                }
                
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "The awesome item goes here"
            gTextField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
    }

}

//MARK: - Search bar extension

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
