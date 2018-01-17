//
//  ViewController.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/16/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item(itemTitle: "First item", itemDone: false)
        itemArray.append(newItem)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItem", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Add button function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var gTextField = UITextField()
        
        let alert = UIAlertController(title: "Lets add something to the list", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let itemString = gTextField.text, !gTextField.text!.isEmpty {
                let newItem = Item(itemTitle: itemString, itemDone: false)
                
                self.itemArray.append(newItem)
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "The awesome item goes here"
            gTextField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

