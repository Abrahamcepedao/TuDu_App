//
//  ActivityCell.swift
//  TuDu
//
//  Created by Abraham Cepeda Oseguera on 12/07/20.
//  Copyright © 2020 Dfuture. All rights reserved.
//

import UIKit

protocol ActivityCellDelegate: AnyObject {
    func editActivityImagePressed(with title: String)
}

class ActivityCell: UITableViewCell {

    @IBOutlet weak var ActivityLbl: UILabel!
    @IBOutlet weak var activityVW: UIView!
    @IBOutlet weak var editActivityIV: UIImageView!
    weak var delegate: ActivityCellDelegate?
    
    public func configure(with title: String){
        ActivityLbl.text = title
        activityVW.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func editActivityImagePressed(){
        print("--- \(ActivityLbl.text!)")
        delegate?.editActivityImagePressed(with: ActivityLbl.text!)
    }
    
    func setUp(){
        let editTap = UITapGestureRecognizer(target: self, action: #selector(ActivityCell.editActivityImagePressed))
        editActivityIV.addGestureRecognizer(editTap)
        editActivityIV.isUserInteractionEnabled = true
    }
}
