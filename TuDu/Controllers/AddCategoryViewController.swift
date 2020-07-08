//
//  AddCategoryViewController.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 08/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import Foundation
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class AddCategoryViewController: UIViewController{
 
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var categoryCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension AddCategoryViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

extension AddCategoryViewController: UICollectionViewDelegate{
    
}
