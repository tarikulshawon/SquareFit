//
//  AppGlobal.swift
//  LiveWallpaper
//
//  Created by Milan Mia on 9/9/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Photos
import PhotosUI
import CoreImage


var unselectedColor = UIColor(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1)
var titleColor = UIColor(red: 122.0/255.0, green: 48.0/255.0, blue: 231.0/255.0, alpha: 1)
let overLayHeight = 300
let canVasHeight = 280
let canvasWidth:CGFloat = 50
let shapeVcHeight = 350
let framesVcHeight = 300
var fliterArray:NSArray!
let adjustHeight = 150
let filterHeight = 300
var fontArray = [String]()
var arrayForFont: NSArray!





func getFilteredImage(withInfo dict: [String : Any]?, for img: UIImage?) -> UIImage? {
    let filterName = dict?["filter"] as? String
    
    let context = CIContext(options: nil)
    let currentFilter = CIFilter(name: filterName ?? "")
    currentFilter?.setDefaults()
    
    var sourceCIImage: CIImage? = nil
    if let img {
        sourceCIImage = CIImage(image: img)
    }
    
    currentFilter?.setValue(
        sourceCIImage,
        forKey: kCIInputImageKey)
    let keys = dict?.keys
    keys?.forEach { key in
        let value = dict?[key] as? String
        if (key != "name") && (key != "filter") && (key != "color") && (key != "ImageName") {
            currentFilter?.setValue(
                NSNumber(value: Double(value ?? "") ?? 0.0),
                forKey: key)
        }
        if key == "color" {
            let colorValue = value?.components(separatedBy: ",")
            var r: Float
            var g: Float
            var b: Float
            r = Float(colorValue?[0] ?? "") ?? 0.0
            g = Float(colorValue?[1] ?? "") ?? 0.0
            b = Float(colorValue?[2] ?? "") ?? 0.0
            
            let color = CIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0))
            
            currentFilter?.setValue(color, forKey: "inputColor")
        }
        
    }
    let adjustedImage = currentFilter?.value(forKey: kCIOutputImageKey) as? CIImage
    var cgimg: CGImage? = nil
    if let adjustedImage {
        cgimg = context.createCGImage(adjustedImage, from: adjustedImage.extent)
    }
    var newImg: UIImage? = nil
    if let cgimg {
        newImg = UIImage(cgImage: cgimg)
    }
    return newImg
}
 
