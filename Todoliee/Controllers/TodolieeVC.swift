//
//  ViewController.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-04.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodolieeVC: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            loadItems()

        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            guard let navbar = navigationController?.navigationBar else{
                fatalError("Navigation controller does not exist")
            }
            
            if let navbarColor = UIColor(hexString: colorHex ){
                navbar.barTintColor = navbarColor
                navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
                navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
                searchBar.barTintColor = navbarColor
            }
          

        }
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError("color eror")}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        

        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                (CGFloat(indexPath.row) / CGFloat(todoItems!.count))){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }

            cell.accessoryType = item.done ? .checkmark : .none

        }else{
            cell.textLabel?.text = "No Items Added"

        }
        
        
        return cell
    }
    //MARK: - Delet from Swipe
    override func updateModel(at indexPath: IndexPath){
        if let itemToBeDeleted = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemToBeDeleted)
                }
            }catch{
                print("deleting error \(error)")
            }
            
        }
    }
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {

                item.done = !item.done
            }
            }catch{
                print("Error saving done status \(error)")
            }
        }
tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //    MARK - Add new item
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todolee item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            if let currentCategory = self.selectedCategory {
                do{
                try self.realm.write {
                    
                    let newItem = Item()
                    
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    
                    currentCategory.items.append(newItem)
                }
                
                }catch{
                    print("Error saving in realm \(error)")
                }
                self.tableView.reloadData()
            }

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {

     todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
//    MARK - Seaarch Bar Extension

extension TodolieeVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            searchBarSearchButtonClicked(searchBar)
        }
    }

}

