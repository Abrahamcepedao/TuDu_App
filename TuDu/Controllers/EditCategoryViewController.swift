//
//  EditCategoryViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 10/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import RealmSwift
class EditCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var colorCV: UICollectionView!
    @IBOutlet weak var deleteBtn: UIButton!
    let realm = try! Realm()
    var categories: Results<Category>?
    var category: Category? = Category()
    var categoryTl: String = ""
    var categoryCr: String = ""
    var colors: [String] = ["4377BB", "A2D39E", "E82851", "F15C65", "1C315F", "6FC6B3", "FBB040", "F16C36", "EC337F", "54B96F", "#2d3436", "#636e72", "#b2bec3", "#dfe6e9", "#e84393", "#fd79a8", "#6c5ce7", "#a29bfe", "#d63031", "#ff7675", "#0984e3", "#74b9ff", "#e17055", "#fab1a0", "#00cec9", "#81ecec", "#fdcb6e", "#ffeaa7", "#00b894", "#55efc4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCV.dataSource = self
        colorCV.delegate = self
        categoryTF.text = category?.title
        deleteBtn.layer.cornerRadius = 15
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
        if categoryTF.text == ""{
            categoryTF.placeholder = "Please add some text.."
        } else{
            categoryTl = categoryTF.text!
            if categoryCr == "" {
                categoryCr = category!.color
            }
            updateCategoryTitle(category: category, newTitle: categoryTl, newColor: categoryCr)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func deleteBtnPressd(_ sender: UIButton) {
        deleteCategory(category: category)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Update Category
    func updateCategoryTitle(category: Category?, newTitle: String, newColor: String){
        do{
            try realm.write{
                category?.title = newTitle
                category?.color = newColor
            }
        } catch{
            print("Error updating category, \(error)")
        }
    }
    
    //MARK: - Delete category
    func deleteCategory(category: Category?){
        do{
            try realm.write{
                self.realm.delete(category!.activities)
                self.realm.delete(category!)
            }
        } catch {
            print("Error deleting category, \(error)")
        }
    }
}

//MARK: - Collection View DataSource Methods
extension EditCategoryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifiers.ECcolorCellCV, for: indexPath)
        cell.backgroundColor = UIColor(hexString: colors[indexPath.row])
        cell.layer.cornerRadius = 20
        return cell
    }
}

extension EditCategoryViewController: UICollectionViewDelegateFlowLayout{
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
