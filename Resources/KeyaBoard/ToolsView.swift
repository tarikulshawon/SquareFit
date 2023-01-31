//
//  ToolsView.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 23/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit


protocol aligthmentTag {
    func changeAlighment(index: Int)
}

protocol chnageFontSize {
    func chnageFontSize(size: Int)
}

protocol chnageAlpa {
    func changeAlpa(value: Float)
}



class ToolsView: UIView {
    public var delegeteAlighment: aligthmentTag?
    public var delegeteFontSize: chnageFontSize?
    public var delegeteForAlpa: chnageAlpa?
    
    
    @IBAction func alightmentDone(_ sender: Any) {
        
        let button = sender as! UIButton
        let tag  = button.tag - 100
        delegeteAlighment?.changeAlighment(index: tag)
    }
    
    
    
    @IBAction func opacityValueChange(_ sender: UISlider) {
        
        delegeteForAlpa?.changeAlpa(value: sender.value)
    }
    @IBAction func textSizeChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        delegeteFontSize?.chnageFontSize(size: currentValue)
    }
    
}
