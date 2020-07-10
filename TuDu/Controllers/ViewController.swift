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
    
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var categories: Results<Category>?
    var activities: Results<Activity>?
    var tappedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: K.Nibs.categoryCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.categoryCellTV)
        tableView.reloadData()
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
            print("Error adding category, \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - Update Category
    func updateCategoryTitle(category: Category, newTitle: String){
        do{
            try realm.write{
                category.title = newTitle
            }
        } catch{
            print("Error updating category, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Category
    func deleteCategory(category: Category){
        do{
            try realm.write{
                self.realm.delete(category)
            }
        } catch{
            print("Error deleting category, \(error)")
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
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
//            let newCategory = Category()
//            newCategory.title = textField.text!
//            newCategory.color = UIColor.randomFlat().hexValue()
//            self.saveCategories(category: newCategory)
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create new category"
//            textField = alertTextField
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: K.Segues.addCategorySegue, sender: self)
    }
}


//MARK: - Table View Data Source Methods - Categories
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories?.count == 0{
            return 1
        } else{
            return categories?.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.categoryCellTV, for: indexPath) as! CategoryCell
        if categories?.count == 0 {
            cell.configure(with: "Create a new category", hexcolor: UIColor.systemBlue.hexValue())
        } else{
            if let category = categories?[indexPath.row] {
                cell.configure(with: category.title, hexcolor: category.color)
            }
        }
        cell.delegate = self
        return cell
    }
    
}
//MARK: - Table View Delegate Methods
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController: CategoryCellDelegate{
    func categoryImageTapped(with title: String) {
        tappedCategory = title
        performSegue(withIdentifier: K.Segues.editCategorySegue, sender: self)
    }
}

//MARK: - Prepare for Segue functions
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.addCategorySegue{
            let destinationVC = segue.destination as! AddCategoryViewController
            destinationVC.categories = categories
        } else if segue.identifier == K.Segues.editCategorySegue{
            let destinationVC = segue.destination as! EditCategoryViewController
            destinationVC.category = getCategory(with: tappedCategory)
        }
        
    }
}
