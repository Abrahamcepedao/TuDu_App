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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
