//
//  EditActivityViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 15/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import RealmSwift

class EditActivityViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var editActivityTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    let realm = try! Realm()
    var activities: Results<Activity>?
    var selectedCategory: Category?
    var selectedActivityS = ""
    var selectedActivityC: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "Edit \(selectedActivityS)"
        loadActivities()
        editActivityTF.text = selectedActivityS
        deleteBtn.layer.cornerRadius = 15
        selectedActivityC = getActivity(with: selectedActivityS)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController as? ViewController {
            DispatchQueue.main.async {
                firstVC.tableView.reloadData()
            }
        }
    }
    
    @IBAction func returnBtnPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        if editActivityTF.text == ""{
            editActivityTF.placeholder = "Please add some text.."
        } else{
            updateActivity(activity: selectedActivityC, newTitle: editActivityTF.text!)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteActivityPressed(_ sender: UIButton) {
        deleteActivity(activity: selectedActivityC!)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Update Activity
    func updateActivity(activity: Activity?, newTitle: String){
        do{
            try realm.write{
                activity?.title = newTitle
            }
        } catch{
            print("Error updating activity, \(error)")
        }
    }
    
    //MARK: - Get Activity
    func getActivity(with title: String) -> Activity?{
        for activity in activities!{
            if activity.title == selectedActivityS{
                return activity
            }
        }
        let newActivity = Activity()
        newActivity.title = "--"
        newActivity.date = Date()
        return newActivity
    }
    
    //MARK: - Delete activity
    func deleteActivity(activity: Activity){
        do{
            try realm.write{
                self.realm.delete(activity)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
    }
    
    //MARK: - Load Activities
    func loadActivities(){
        activities = selectedCategory?.activities.sorted(byKeyPath: "title", ascending: true)
    }
}
