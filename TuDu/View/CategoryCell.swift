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
    func addActivityImageTapped(with title: String)
    func editActivityImageTapped(with title: String, and categoryTitle: String)
    func deleteActivityImageTapped(with title: String, and categoryTitle: String)
}

class CategoryCell: UITableViewCell {

    let realm = try! Realm()
    weak var delegate: CategoryCellDelegate?
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryIV: UIImageView!
    @IBOutlet weak var addActivityIV: UIImageView!
    @IBOutlet weak var activitiesTV: UITableView!
    var activities: Results<Activity>?
    var categories: Results<Category>?
    var activity: Activity?
    var currentCategory: Category?
    private var categoryTitle = ""
    
    public func configure(with title: String, hexcolor: String, type: Bool){
        guard let color = UIColor(hexString: hexcolor) else{fatalError("No category")}
        var constrastColor = ContrastColorOf(color, returnFlat: true)
        constrastColor = constrastColor.hexValue() != "#262626" ? ContrastColorOf(color, returnFlat: true) : color.darken(byPercentage: 0.5)!
        categoryLbl.text =  title
        self.categoryTitle = title
        categoryView.backgroundColor = color
        categoryLbl.textColor = constrastColor
        categoryView.layer.cornerRadius = 15
        addActivityIV.tintColor = constrastColor
        categoryIV.tintColor = constrastColor
        if type {
            addActivityIV.isHidden = false
            categoryIV.isHidden = false
            activitiesTV.delegate = self
            activitiesTV.separatorStyle = .none
            currentCategory = getCategory(with: categoryLbl.text!)
            loadActivities()
            activitiesTV.reloadData()
            activitiesTV.backgroundColor = color
        }
        if title == "Create a new category"{
            addActivityIV.isHidden = true
            categoryIV.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTV()
        loadCategories()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func categoryImageTapped(){
        delegate?.categoryImageTapped(with: categoryTitle)
    }
    
    @objc func addActivityImageTapped(){
        delegate?.addActivityImageTapped(with: categoryTitle)
    }
    
    @objc func editActivityImageTapped(with title: String, and categoryTitle: String){
        delegate?.editActivityImageTapped(with: title, and: categoryTitle)
    }
    
    @objc func deleteActivityImageTapped(with title: String, and categoryTitle: String){
        delegate?.deleteActivityImageTapped(with: title, and: categoryTitle)
    }
    
    func setUpTV(){
        let editTap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.categoryImageTapped))
        categoryIV.addGestureRecognizer(editTap)
        categoryIV.isUserInteractionEnabled = true
        let addTap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.addActivityImageTapped))
        addActivityIV.addGestureRecognizer(addTap)
        addActivityIV.isUserInteractionEnabled = true
        activitiesTV.dataSource = self
        activitiesTV.register(UINib(nibName: K.Nibs.activityCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.activityCellTV)
    }
    
}

extension CategoryCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //countActivitiesInCategory()
        if categories?.count != 0{
            if  activities?.count == 0{
                return 1
            } else{
                return activities?.count ?? 1
            }
        } else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.activityCellTV, for: indexPath) as! ActivityCell
        if activities?.count == 0{
            cell.configure(with: "Add items", color: "000000", status: false)
        } else{
            cell.configure(with: activities?[indexPath.row].title ?? "new activity", color: categoryView.backgroundColor!.hexValue(), status: activities?[indexPath.row].status ?? false)
            cell.delegate = self
        }
        cell.selectionStyle = .none
        cell.backgroundColor = categoryView.backgroundColor
        return cell
    }
}

//MARK: - Table View Delegate Methods
extension CategoryCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if activities?.count != 0{
            let cell = tableView.cellForRow(at: indexPath) as! ActivityCell
            updateActivityStatus(with: cell.ActivityLbl.text!)
            tableView.reloadData()
        } else{
            addActivityImageTapped()
        }
        
    }
}

//MARK: - Category Activity Delegate Methods
extension CategoryCell: ActivityCellDelegate{
    func deleteActivityImagePressed(with title: String) {
        deleteActivityImageTapped(with: title, and:categoryLbl.text ?? "default")
    }
    
    func editActivityImagePressed(with title: String) {
        editActivityImageTapped(with: title, and: categoryLbl.text ?? "default")
        activitiesTV.reloadData()
    }
}

//MARK: - Data Methods
extension CategoryCell{
    //MARK: - Load Categories
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    //MARK: - getCategory
    func getCategory(with title: String) -> Category{
        for category in categories!{
            if category.title == title{
                return category
            }
        }
        let newCategory = Category()
        newCategory.title = "New category"
        newCategory.color = UIColor.randomFlat().hexValue()
        return newCategory
    }
    
    //MARK: - Load Activities
    func loadActivities(){
        activities = currentCategory?.activities.sorted(byKeyPath: "title", ascending: true)
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
    
    //MARK: - Update Activity Status
    func updateActivityStatus(with title: String){
        let activity = getActivity(with: title)
        do{
            try realm.write{
                activity!.status =  !activity!.status
            }
        } catch {
            print("Error updating activity satus, \(error)")
        }
    }
}


