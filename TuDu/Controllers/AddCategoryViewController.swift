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

    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var colorCV: UICollectionView!
    let realm = try! Realm()
    var categories: Results<Category>?
    var newCategory = Category()
    var categoryTl: String = ""
    var categoryCr: String = ""
    var colors: [String] = ["4377BB", "A2D39E", "E82851", "F15C65", "1C315F", "6FC6B3", "FBB040", "F16C36", "EC337F", "54B96F", "#2d3436", "#636e72", "#b2bec3", "#dfe6e9", "#e84393", "#fd79a8", "#6c5ce7", "#a29bfe", "#d63031", "#ff7675", "#0984e3", "#74b9ff", "#e17055", "#fab1a0", "#00cec9", "#81ecec", "#fdcb6e", "#ffeaa7", "#00b894", "#55efc4", "#1abc9c", "#16a085", "#2ecc71", "#27ae60", "#2980b9", "#3498db", "#c0392b", "#e74c3c", "#d35400", "#e67e22", "#f39c12", "#f1c40f", "#2c3e50", "#34495e", "#7f8c8d", "#95a5a6",  "#bdc3c7", "#ecf0f1", "2081C3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        colorCV.dataSource = self
        colorCV.delegate = self
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
        if categoryTF.text == ""{
            categoryTF.placeholder = "Please add some text.."
        } else{
            categoryTl = categoryTF.text!
            newCategory.title = categoryTl
            if categoryCr == "" {
                let randomNum = Int.random(in: 0..<colors.count)
                newCategory.color = colors[randomNum]
            }  else{
                newCategory.color = categoryCr
            }
            saveCategories(category: newCategory)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
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
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifiers.ACcolorCellCV, for: indexPath)
        cell.backgroundColor = UIColor(hexString: colors[indexPath.row])
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
        categoryCr = colors[indexPath.row]
    }
}
