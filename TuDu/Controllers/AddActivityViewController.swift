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

    @IBOutlet weak var activityTF: UITextField!
    let realm = try! Realm()
    var categories: Results<Category>?
    @IBOutlet weak var categoriesCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func returnBtnPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddActivityViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifiers.ACcolorCellCV, for: indexPath)
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
        for cells in collectionView.visibleCells {
            if cells != cell{
                cells.layer.cornerRadius = 20
            }
        }
        cell?.layer.cornerRadius = 5
    }
}
