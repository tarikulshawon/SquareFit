//
//  ExpandableCellTableViewCell.swift
//  ExpandableTableView
//
//  Created by MacBook Pro Retina on 8/11/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit

class ExpandableCellTableViewCell: UITableViewCell {

    
    @IBOutlet var widthForImv: NSLayoutConstraint!
    @IBOutlet var containerview: UIView!
    @IBOutlet var imv: UIImageView!
    
    @IBOutlet var newView: UIView!
    @IBOutlet var lbl: UILabel!
    
    @IBOutlet var trailingSpace: NSLayoutConstraint!
    @IBOutlet var headerView1: UIView!
    
    @IBOutlet var lbl1: UILabel!
    
    @IBOutlet var leadingSpace: NSLayoutConstraint!
    
    @IBOutlet var expandableView: UIView!
    
    @IBOutlet var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
