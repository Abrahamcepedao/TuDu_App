//
//  ActivityCell.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 12/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var ActivityLbl: UILabel!
    @IBOutlet weak var activityVW: UIView!
    
    public func configure(with title: String){
        ActivityLbl.text = title
        activityVW.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
