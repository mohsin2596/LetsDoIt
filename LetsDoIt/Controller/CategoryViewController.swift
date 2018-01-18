//
//  CategoryViewController.swift
//  LetsDoIt
//
//  Created by Mohsin Ajmal on 1/18/18.
//  Copyright © 2018 Mohsin Ajmal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    var selectedCategory : Category?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
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
                
                let newCategory = Category(context: self.context)
                newCategory.name = categoryName
                self.categoryArray.append(newCategory)
                self.saveCategory()
                
                
            }
            
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data retrieval methods
    func saveCategory(){
        do {
            try context.save()
        }
        catch {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching category: \(error)")
        }
        tableView.reloadData()
    }
}
