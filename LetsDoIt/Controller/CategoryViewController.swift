//
//  CategoryViewController.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/18/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    var selectedCategory : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added"
        
        if let colorHex = categoryArray?[indexPath.row].color {
            cell.backgroundColor = UIColor.init(hexString: colorHex)
        }
        else {
            cell.backgroundColor = UIColor.randomFlat()
        }
        
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor, isFlat:true)
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryArray?[indexPath.row]
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.selectedCategory = selectedCategory!
    }
    
    //MARK: - Add button method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var gTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Give your new category a name", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            gTextField = alertTextField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let categoryName = gTextField.text, !gTextField.text!.isEmpty {
                
                let newCategory = Category()
                newCategory.name = categoryName
                newCategory.color = UIColor.randomFlat().hexValue()
                self.saveCategory(category: newCategory)
                
                
            }
            
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Data retrieval methods
    func saveCategory(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        if let deleteCategory = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deleteCategory)
                }
            }
            catch {
                print("Error deleting: \(error)")
            }

        }
    }
    
}


