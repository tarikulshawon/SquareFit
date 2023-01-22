//
//  KeyboardTopView.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 23/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit

enum KeyboardAccessory: CaseIterable {
    case keyboard
    case font
    case color
    case alignment
    case done
}

protocol indexItem {
    func changeIndex(index: Int)
}


class KeyboardTopView: UIView {
    
    
  public var delegate: indexItem?

    @IBOutlet var tabBarView: UITabBar!
    
    override func draw(_ rect: CGRect) {
        self.tabBarView.delegate = self
    }
    
}


extension KeyboardTopView : UITabBarDelegate {
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let value = item.tag-300
        delegate?.changeIndex(index: value)
    }
}
