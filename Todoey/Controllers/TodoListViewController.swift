//
//  ViewController.swift
//  Todoey
//
//  Created by Antonello Fazio on 15/9/18.
//  Copyright © 2018 Malcom Logan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    @IBOutlet var toDoTableView: UITableView!

    
    var itemArray : Array = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        configureTableView()
        
        loadItems()
                
    }


    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoTableViewCell
        
        let item = itemArray[indexPath.row]
        cell.toDoLabel.text = item.title
        
         cell.accessoryType = item.done ? .checkmark : .none // il codice accanto (Ternary operator) esprime in una riga quello che c'è commentato qui sotto
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text == "" {
                
            } else {
                
                let itemAdded = Item()
                itemAdded.title = textField.text!
                self.itemArray.append(itemAdded)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(addItemAction)
        present(alert, animated: true, completion: nil)
    }
    
    func configureTableView() {
        toDoTableView.rowHeight = UITableView.automaticDimension
        toDoTableView.estimatedRowHeight = 120
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item Array: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array: \(error)")
            }
        }
    }
    
}

