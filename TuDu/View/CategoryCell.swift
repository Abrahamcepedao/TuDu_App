//
//  CategoryTableViewCell.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 03/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol CategoryCellDelegate: AnyObject {
    func categoryImageTapped(with title: String)
}

class CategoryCell: UITableViewCell {

    weak var delegate: CategoryCellDelegate?
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryVI: UIImageView!
    @IBOutlet weak var activitiesTV: UITableView!
    
    private var categoryTitle = ""
    
    public func configure(with title: String, hexcolor: String){
        guard let color = UIColor(hexString: hexcolor) else{fatalError("No category")}
        categoryLbl.text =  title
        self.categoryTitle = title
        categoryView.backgroundColor = color
        categoryLbl.textColor = ContrastColorOf(color, returnFlat: true)
        categoryView.layer.cornerRadius = 15
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.categoryImageTapped))
        categoryVI.addGestureRecognizer(tap)
        categoryVI.isUserInteractionEnabled = true
        activitiesTV.dataSource = self
        activitiesTV.register(UINib(nibName: K.Nibs.activityCellNib, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.activityCellTV)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func categoryImageTapped(){
        delegate?.categoryImageTapped(with: categoryTitle)
    }
    
}

extension CategoryCell{
    func  setTableViewDataSourceDelegate<D:UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate: D, forRow row: Int){
        activitiesTV.delegate = dataSourceDelegate
        activitiesTV.dataSource = dataSourceDelegate
        activitiesTV.reloadData()
    }
}
extension CategoryCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifiers.activityCellTV, for: indexPath) as! ActivityCell
        cell.ActivityLbl.text = "Test"
        return cell
    }


}
