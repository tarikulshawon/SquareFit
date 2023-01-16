//
//  CanvasRatioCell.swift
//  RatioPOC
//
//  Created by Sadiqul Amin on 16/1/23.
//

import UIKit



class CanvasRatioCell: UICollectionViewCell {
    
   

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var widthR: NSLayoutConstraint!
    @IBOutlet weak var heightR: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
    }
    
    public static var reusableID: String {
        return String(describing: CanvasRatioCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: reusableID, bundle: nil)
    }

}
