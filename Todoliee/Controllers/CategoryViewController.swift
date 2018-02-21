//
//  CategoryViewController.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-16.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategories()
    }
    //    MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category created yet!"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
       
        return cell
    }
    

    

    
    
    //    MARK: - Add new Categories
    

    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todolee Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
 
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()


            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    //    MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolieeVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    //MARK: - Delet from Swipe
    override func updateModel(at indexPath: IndexPath){
        if let categoryToBeDeleted = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryToBeDeleted)
                }
            }catch{
                print("deleting error \(error)")
            }
            
        }
    }
    //    MARK: - Data Manuplation Methods
    func save(category: Category){
        
        do{
            
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error saving message \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
 
        tableView.reloadData()
    }
}






