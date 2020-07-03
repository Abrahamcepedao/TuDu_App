//
//  ViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 02/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var activities: Results<Activity>?
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        TableView.dataSource = self
        TableView.delegate = self
        TableView.separatorStyle = .none
        // loadActivities()
        
    }
    
    //MARK: - Table View Data Source Methods - Categories
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let category = categories?[indexPath.row] {
            print(category.title)
            cell.textLabel?.text = category.title
            guard let color = UIColor(hexString: category.color) else{fatalError("No category")}
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        } else{
            cell.textLabel?.text = "Create a new category"
            cell.backgroundColor = UIColor.systemBlue
        }
        cell.layer.cornerRadius = cell.frame.height / 5
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Data Manipulation Methods
    //MARK: - Load Categories
    func loadCategories(){
        categories = realm.objects(Category.self)
        TableView.reloadData()
        if let category = categories?[0]{
            print(category.title)
        }
    }
    
    //MARK: - Save Categories to Plist
    func saveCategories(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error encoding itemArray, \(error)")
        }
        TableView.reloadData()
    }
    
    @IBAction func BtnAddCategory(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.title = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

