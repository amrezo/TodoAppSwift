//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by Amr Al-Refae on 2/22/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit

// TodoField to be used in adding item to list
var todoField: UITextField?

// TodoArray used for storing the todo items
var todosArray = [String]()

class TodoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // When the todo array is empty, display the placeholder
        
        if todosArray.count == 0 {
            
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
        return todosArray.count
    }
    
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        // Creating an alert with a textfield and an Add button
        let alert = UIAlertController(title: "Add Item", message: "Insert a todo item:", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Add", style: .default) { (okButton) in
            self.addToList()
        }
        
        // Create the todo textfield for the alert
        let textField = UITextField()
        textField.placeholder = "Eg. Work"
        
        // Add both the Add button and textfield into the alert
        alert.addAction(okButton)
        alert.addTextField { (textField) in
            todoField = textField
        }
        
        // Present the alert
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // Function to add the todo item to the array and update tableView to show it
    
    func addToList() {
        todosArray.append((todoField?.text!)!)
        self.tableView.reloadData()
    }
    
    // Create cells with text label showing the todo items in array
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        cell.textLabel?.text = todosArray[indexPath.item]

        return cell
        
    }
    
    // Add a checkmark to selected todo item cells and remove when tapped on again
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            tableView.cellForRow(at: indexPath)?.isSelected = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            tableView.cellForRow(at: indexPath)?.isSelected = true
        }
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            todosArray.remove(at: indexPath.row)
            
            // Delete the row from the tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        // Reload the data in the table
        tableView.reloadData()
    }
    
}
