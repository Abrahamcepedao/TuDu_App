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
    let realm = try! Realm()
    var categories: Results<Category>?
    var category: Category? = Category()
    var categoryTl: String = ""
    var categoryCr: String = ""
    var colors: [String] = ["4377BB", "A2D39E", "E82851", "F15C65", "1C315F", "6FC6B3", "FBB040", "F16C36", "EC337F", "54B96F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCV.dataSource = self
        colorCV.delegate = self
        categoryTF.placeholder = category?.title
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
