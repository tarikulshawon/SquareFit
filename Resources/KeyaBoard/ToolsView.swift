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
protocol chnageLineSpacing {
    func chnageLineSpacing(size: Int)
}
protocol chnageCharacterSpace {
    func chnageCharacterSpace(size: Int)
}

class ToolsView: UIView {
    
    
    
    public var delegeteAlighment: aligthmentTag?
    public var delegeteFontSize: chnageFontSize?
    public var delegeteLineSpacing: chnageLineSpacing?
    public var delegeteCharacterSpacing: chnageCharacterSpace?
    
    
    @IBAction func alightmentDone(_ sender: Any) {
        
        let button = sender as! UIButton
        let tag  = button.tag - 100
        delegeteAlighment?.changeAlighment(index: tag)
        
        
        
    }
    
    @IBAction func textSizeChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        delegeteFontSize?.chnageFontSize(size: currentValue)
        
        
    }
    
    @IBAction func changeLineSpacing(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        delegeteLineSpacing?.chnageLineSpacing(size: currentValue)
        
    }
    
    
    @IBAction func chnageCharacterSpacing(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        delegeteCharacterSpacing?.chnageCharacterSpace(size: currentValue)
    }
    
}
