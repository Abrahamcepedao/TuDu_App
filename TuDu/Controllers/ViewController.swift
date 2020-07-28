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
    @IBOutlet weak var addCategoryButton: UIButton!
    let realm = try! Realm()
    var categories: Results<Category>?
    var activities: Results<Activity>?
    var tappedCategory = ""
    var tappedActivity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: K.Nibs.categoryCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.categoryCellTV)
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
        addCategoryButton.backgroundColor = GradientColor(UIGradientStyle.leftToRight, frame: addCategoryButton.frame.self, colors: [HexColor("6FC6B3")!, HexColor("4377BB")!])
    }
    override func viewDidDisappear(_ animated: Bool) {
        if categories?.count != 0{
            do{
                try realm.write{
                    for category in categories!{
                        category.selected = false
                    }
                }
            } catch{
                print("Error updating categories, \(error)")
            }
        }
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
    //MARK: - Update Category Title
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
    
    //MARK: - Update Category Selected
    func updateSelectedCategory(with category: Category?){
        do{
            try realm.write{
                category?.selected = !category!.selected
            }
        } catch{
            print("Error updating category \(error)")
        }
    }
    
    //MARK: - Load Activities
    func loadCategories(with category: Category?){
        activities = category?.activities.sorted(byKeyPath: "title", ascending: true)
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
    
    //MARK: - Get Activity
    func getActivity(with title: String) -> Activity?{
        for activity in activities!{
            if activity.title == title{
                return activity
            }
        }
        let newActivity = Activity()
        newActivity.title = "--"
        newActivity.date = Date()
        return newActivity
    }
    
    //MARK: - Delete activity
    func deleteActivity(with title: String){
        let activity =  getActivity(with: title)
        do{
            try realm.write{
                self.realm.delete(activity!)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func BtnAddCategory(_ sender: UIButton) {
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
            cell.configure(with: "Create a new category", hexcolor: UIColor.systemBlue.hexValue(), type: false)
        } else{
            if let category = categories?[indexPath.row] {
                cell.configure(with: category.title, hexcolor: category.color, type: true)
            }
        }
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

//MARK: - Table View Delegate Methods
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if categories?.count ?? 0 > 0{
            updateSelectedCategory(with: categories?[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .left)
        } else{
            performSegue(withIdentifier: K.Segues.addCategorySegue, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if categories?.count ?? 0 > 0{
            if categories?[indexPath.row].selected ?? false{
                loadCategories(with: categories?[indexPath.row])
                if activities?.count ?? 0 > 1{
                    return (140 + (CGFloat(activities?.count ?? 1)-1)*50)
                }
                return 140
            }
        }
        return 70
        
    }
}

//MARK: - Category Cell Delegate Methods
extension ViewController: CategoryCellDelegate{
    
    func categoryImageTapped(with title: String) {
        tappedCategory = title
        performSegue(withIdentifier: K.Segues.editCategorySegue, sender: self)
    }
    
    func editActivityImageTapped(with title: String, and categoryTitle: String) {
        tappedActivity = title
        tappedCategory = categoryTitle
        performSegue(withIdentifier: K.Segues.editActivitySegue, sender: self)
    }
    func addActivityImageTapped(with title: String) {
        tappedCategory = title
        performSegue(withIdentifier: K.Segues.addActivitySegue, sender: self)
    }
    func deleteActivityImageTapped(with title: String, and categoryTitle: String) {
        loadCategories(with: getCategory(with: categoryTitle))
        deleteActivity(with: title)
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
        } else if segue.identifier == K.Segues.addActivitySegue{
            let destinationVC = segue.destination as! AddActivityViewController
            destinationVC.selectedCategory = getCategory(with: tappedCategory)
        } else if segue.identifier == K.Segues.editActivitySegue{
            let destinationVC = segue.destination as! EditActivityViewController
            destinationVC.selectedActivityS = tappedActivity
            destinationVC.selectedCategory = getCategory(with: tappedCategory)
        }
    }
}
