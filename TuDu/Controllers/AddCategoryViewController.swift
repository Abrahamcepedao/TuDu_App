//
//  AddCategoryViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 08/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class AddCategoryViewController: UIViewController{

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryCV: UICollectionView!
    let realm = try! Realm()
    var categories: Results<Category>?
    var newCategory = Category()
    var categoryTitle: String = ""
    var categoryColor: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCV.dataSource = self
        categoryCV.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController as? ViewController {
            DispatchQueue.main.async {
                firstVC.tableView.reloadData()
            }
        }
    }

    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        categoryTitle = categoryTextField.text!
        newCategory.title = categoryTitle
        newCategory.color = categoryColor
        saveCategories(category: newCategory)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Save NewCategory to Plist
    func saveCategories(category: Category){
       do{
           try realm.write{
               realm.add(category)
           }
       } catch{
           print("Error encoding itemArray, \(error)")
       }
    }
}

extension AddCategoryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(categories?.count ?? 0)")
        return categories?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCellCV", for: indexPath)
        print(categories?[indexPath.row].title ?? "default")
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "ffffff")
        cell.layer.cornerRadius = 20
        return cell
    }
}

extension AddCategoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        for cells in collectionView.visibleCells {
            if cells != cell{
                cells.layer.cornerRadius = 20
            }
        }
        cell?.layer.cornerRadius = 5
        categoryColor = categories?[indexPath.row].color ?? "ffffff"
        print("Color: \(categoryColor)")
    }
}
