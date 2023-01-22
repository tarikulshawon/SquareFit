//
//  ColorView.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 23/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit


protocol chnageColor {
    func chnageColorForView(color: UIColor)
}

class ColorView: UIView {
     
    
   private var colorWheel: RotatingColorWheel!
   public var delegateForColor: chnageColor?

    override func draw(_ rect: CGRect)
    {
        colorWheel = RotatingColorWheel(frame:  CGRect(x: 0, y: 0, width:self.frame.size.width, height: self.frame.size.height))
       colorWheel.delegate = self
       colorWheel.backgroundColor = UIColor.clear
       self.addSubview(colorWheel)
        
    }
    
}

extension ColorView: ColorWheelDelegate {
    
    
    func didSelect(color: UIColor) {
        delegateForColor?.chnageColorForView(color: color)

        
    }
}
