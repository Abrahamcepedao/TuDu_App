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
    var categories: Results<Category>?
    var selectedCategory: Category?
    @IBOutlet weak var activityTF: UITextField!
    @IBOutlet weak var categoriesCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCV.dataSource = self
        categoriesCV.delegate = self
        loadCategories()
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
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        categoriesCV.reloadData()
    }
    
}

extension AddActivityViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifiers.AAcategoryCell, for: indexPath)
        cell.backgroundColor = UIColor(hexString: categories![indexPath.row].color)
        cell.layer.cornerRadius = 20
        return cell
    }
}

extension AddActivityViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedCategory = categories?[indexPath.row]
        for cells in collectionView.visibleCells {
            if cells != cell{
                cells.layer.cornerRadius = 20
            }
        }
        cell?.layer.cornerRadius = 5
    }
}
