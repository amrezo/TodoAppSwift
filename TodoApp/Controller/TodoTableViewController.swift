//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by Amr Al-Refae on 2/22/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import RealmSwift


class TodoTableViewController: UITableViewController {
    
    // Realm var for easy access
    var realm: Realm!
    
    // Todo list that will store the todo items
    var toDoList: Results<ToDoListItem> {
        
        get {
            return realm.objects(ToDoListItem.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init realm
        realm = try! Realm()
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // When the todo list is empty, display the placeholder
        
        if toDoList.count == 0 {
            
            // Placeholder creation, displayed when the tableView is empty
            let placeholderTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            placeholderTitle.font = UIFont(name: "Avenir Next", size: CGFloat(integerLiteral: 27))
            placeholderTitle.numberOfLines = 2
            placeholderTitle.textColor = .black
            placeholderTitle.center = CGPoint(x: 160, y: 284)
            placeholderTitle.textAlignment = .center
            placeholderTitle.text = "Hurray! You don't have any todos. 😃"
            
            // Remove separation line in tableView and add placeholder to its backgroundView
            tableView.separatorStyle = .none
            tableView.backgroundView = placeholderTitle
            
        } else {
            
            // Reset tableView to original settings and remove separatipn line in empty cells
            tableView.backgroundView = UIView()
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
        }
        
        //Number of sections in this todo-list
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of items in the todoArray as number of rows
        return toDoList.count
    }
    
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        // Creating an alert with a textfield and Add/Cancel actions
        let alert = UIAlertController(title: "Add Item", message: "What do you want to do?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "E.g. Feed the cat"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let todoItemTextField = (alert.textFields?.first)! as UITextField
            
            let newToDoListItem = ToDoListItem()
            newToDoListItem.name = todoItemTextField.text!
            newToDoListItem.done = false
            
            try! self.realm.write({
                
                self.realm.add(newToDoListItem)
            })
            
            self.tableView.insertRows(at: [IndexPath.init(row: self.toDoList.count - 1, section: 0)], with: .automatic)

        }
        alert.addAction(addAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
  
    }
    
    
    // Create cells with text label showing the todo items in array
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let item = toDoList[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        //Ternary operator - basically an if-else statement
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = toDoList[indexPath.row]
        
        try! self.realm.write ({
            item.done = !item.done
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = toDoList[indexPath.row]
            
            try! self.realm.write({
                
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
}
