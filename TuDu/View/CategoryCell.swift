//
//  CategoryTableViewCell.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 03/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit
import ChameleonFramework
class CategoryCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewImage: UIImageView!
    
    public func configure(with title: String, hexcolor: String){
        guard let color = UIColor(hexString: hexcolor) else{fatalError("No category")}
        categoryLabel.text =  title
        categoryView.backgroundColor = color
        categoryLabel.textColor = ContrastColorOf(color, returnFlat: true)
        categoryView.layer.cornerRadius = categoryView.frame.size.height / 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
