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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewImage: UIImageView!
    private var categoryTitle = ""
    
    public func configure(with title: String, hexcolor: String){
        guard let color = UIColor(hexString: hexcolor) else{fatalError("No category")}
        categoryLabel.text =  title
        self.categoryTitle = title
        categoryView.backgroundColor = color
        categoryLabel.textColor = ContrastColorOf(color, returnFlat: true)
        categoryView.layer.cornerRadius = categoryView.frame.size.height / 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.categoryImageTapped))
        categoryViewImage.addGestureRecognizer(tap)
        categoryViewImage.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func categoryImageTapped(){
        delegate?.categoryImageTapped(with: categoryTitle)
    }
    
}
