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

class ViewController: UIViewController {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var activities: Results<Activity>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        // loadActivities()
        
    }
    
    
    //MARK: - Data Manipulation Methods
    //MARK: - Load Categories
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
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
        tableView.reloadData()
    }
    
    func updateCategoryTitle(category: Category, newTitle: String){
        do{
            try realm.write{
                category.title = newTitle
            }
        } catch{
            print("Error encoding itemArray, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Fecth Data Methods
    func getCategory(with title: String) -> Category{
        for category in categories!{
            if category.title == title{
                return category
            }
        }
        let newCategory = Category()
        newCategory.title = "New category"
        newCategory.color = UIColor.randomFlat().hexValue()
        saveCategories(category: newCategory)
        return newCategory
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


//MARK: - Table View Data Source Methods - Categories
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        if let category = categories?[indexPath.row] {
            cell.configure(with: category.title, hexcolor: category.color)
        } else{
            cell.categoryLabel.text = "Create a new category"
            cell.categoryView.backgroundColor = UIColor.systemBlue
        }
        cell.delegate = self
        return cell
    }
    
}

extension ViewController: UITableViewDelegate{
    //MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: CategoryCellDelegate{
    func categoryImageTapped(with title: String) {
        var textField = UITextField()
        let alert = UIAlertController(title: "\(title)", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Rename category", style: .default) { (action) in
            let category = self.getCategory(with: title)
            let newTitle = textField.text!
            self.updateCategoryTitle(category: category, newTitle: newTitle)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Rename category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("\(title)")
    }
    
    
}
