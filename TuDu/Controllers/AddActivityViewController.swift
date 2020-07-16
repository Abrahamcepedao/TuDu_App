//
//  AddActivityViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 14/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import RealmSwift
class AddActivityViewController: UIViewController {
    
    let realm = try! Realm()
    var selectedCategory: Category?
    @IBOutlet weak var activityTF: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "Add to \(selectedCategory?.title ?? "Category")"
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
        if activityTF.text == ""{
            activityTF.placeholder = "Please add some text.."
        } else{
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newActivity = Activity()
                        newActivity.title = activityTF.text!
                        newActivity.date = Date()
                        currentCategory.activities.append(newActivity)
                    }
                } catch{
                    print("Error saving activity \(error)")
                }
            }
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}


