//
//  CategoryTableViewCell.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 03/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

protocol CategoryCellDelegate: AnyObject {
    func categoryImageTapped(with title: String)
}

class CategoryCell: UITableViewCell {

    let realm = try! Realm()
    weak var delegate: CategoryCellDelegate?
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryVI: UIImageView!
    @IBOutlet weak var activitiesTV: UITableView!
    var activities: Results<Activity>?
    var categories: Results<Category>?
    var currentCategory: Category?
    
    private var categoryTitle = ""
    
    public func configure(with title: String, hexcolor: String){
        guard let color = UIColor(hexString: hexcolor) else{fatalError("No category")}
        categoryLbl.text =  title
        self.categoryTitle = title
        categoryView.backgroundColor = color
        categoryLbl.textColor = ContrastColorOf(color, returnFlat: true)
        categoryView.layer.cornerRadius = 15
        activitiesTV.delegate = self
        activitiesTV.separatorStyle = .none
        currentCategory = getCategory(with: categoryLbl.text!)
        loadActivities()
        activitiesTV.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTV()
        loadCategories()
//        if activities?.count ?? 0 > 0{
//            print(activities?[0].title)
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func categoryImageTapped(){
        delegate?.categoryImageTapped(with: categoryTitle)
    }
    
    func setUpTV(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.categoryImageTapped))
        categoryVI.addGestureRecognizer(tap)
        categoryVI.isUserInteractionEnabled = true
        activitiesTV.dataSource = self
        activitiesTV.register(UINib(nibName: K.Nibs.activityCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.activityCellTV)
    }
    
}

extension CategoryCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //countActivitiesInCategory()
        if  activities?.count == 0{
            return 1
        } else{
            return activities?.count ?? 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.activityCellTV, for: indexPath) as! ActivityCell
        if activities?.count == 0{
            cell.configure(with: "Add items")
        } else{
            cell.configure(with: activities?[indexPath.row].title ?? "default")
        }
        cell.backgroundColor = categoryView.backgroundColor
//        currentCategory = getCategory(with: categoryLbl.text!)
        print("category - \(currentCategory?.title ?? "default")")
        return cell
    }
}

//MARK: - Table View Delegate Methods
extension CategoryCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


//MARK: - Data Methods
extension CategoryCell{
    //MARK: - Load Categories
    func loadCategories(){
        categories = realm.objects(Category.self)
        print(currentCategory?.title ?? "default")
//        tableView.reloadData()
    }
    
    //MARK: - Load Activities
    func loadActivities(){
        print("loading activities...")
        activities = currentCategory?.activities.sorted(byKeyPath: "title", ascending: true)
    }
    
    //MARK: - getCategory
    func getCategory(with title: String) -> Category{
        for category in categories!{
            print(category.title)
            print(title)
            if category.title == title{
                return category
            }
        }
        let newCategory = Category()
        newCategory.title = "New category"
        newCategory.color = UIColor.randomFlat().hexValue()
        return newCategory
    }
}
