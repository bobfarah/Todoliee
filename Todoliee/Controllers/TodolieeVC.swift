//
//  ViewController.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-04.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class TodolieeVC: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title =  "Find Milk"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        
        newItem2.title =  "Goosal"
        itemArray.append(newItem2)
        
        let newItem3 = Item()

        newItem3.title =  "Akhmal"
        itemArray.append(newItem3)
        
  
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
       
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
      
        return cell
    }
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    MARK - Add new item
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todolee item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //            what will happen when the user click on the add item buttn
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

