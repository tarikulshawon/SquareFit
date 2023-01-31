//
//  Shadow.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 29/1/23.
//

import UIKit

protocol shadowDelegate: AnyObject {
    
    func opacityShadowValue(value:Double)
    func radiusShadowalue(value:Double)
    func offsetShadowValue(value:Double)
    
}

class Shadow: UIView {

    @IBOutlet weak var sliderForOffset: GradientSlider!
    @IBOutlet weak var sliderForOpacity: GradientSlider!
    @IBOutlet weak var sliderForRadius: GradientSlider!

    weak var delegateForShadow: shadowDelegate?
    
    
    override func draw(_ rect: CGRect) {
        
        sliderForOffset.thickness = 5
        sliderForOpacity.thickness = 5
        sliderForRadius.thickness = 5
        
        
        sliderForRadius.maximumValue = 15
        sliderForRadius.minimumValue = 0
        
        sliderForOffset.maximumValue = 5
        sliderForOffset.minimumValue = -5
        
        sliderForOpacity.maximumValue = 1.0
        sliderForOpacity.minimumValue = 0.0
        
    }
    
    @IBAction func offsetValueChanged(_ sender: GradientSlider) {
        delegateForShadow?.offsetShadowValue(value: Double(sender.value))
    }
    
    @IBAction func opacityShadowValueChanged(_ sender: GradientSlider) {
        delegateForShadow?.opacityShadowValue(value:  Double(sender.value))
    }
    
    
    @IBAction func radiusValueChanged(_ sender: GradientSlider) {
        delegateForShadow?.radiusShadowalue(value:  Double(sender.value))
    }
    

}
