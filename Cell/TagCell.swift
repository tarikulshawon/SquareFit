//
//  TagCell.swift
//  SquareFit
//
//  Created by tarikul shawon on 22/1/23.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet private weak var tagLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.contentView.backgroundColor = titleColor
            } else {
                self.contentView.backgroundColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 10
    }

    func prepare(with text: String) {
        tagLabel.text = text
    }
}
