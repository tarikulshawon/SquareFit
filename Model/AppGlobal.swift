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
var plistArray1: NSArray!
var plistArray: NSArray!

let no_Of_blur = 10


func getColor(colorString: String) -> UIColor {
    var array = colorString.components(separatedBy: ",")
    if let firstNumber = array[0] as? String,
       let secondNumber = array[1] as? String,
       let thirdNumber = array[2] as? String {
        
        if let f1  = Double(firstNumber.trimmingCharacters(in: .whitespacesAndNewlines)),
           let f2 = Double (secondNumber.trimmingCharacters(in: .whitespacesAndNewlines)),
           let f3 = Double(thirdNumber.trimmingCharacters(in: .whitespacesAndNewlines)) {
            
            return UIColor(red: f1/255.0 , green: f2/255.0 , blue: f3/255.0 , alpha: 1.0)
        }
    }
    
    return UIColor.black
}


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
 

extension DispatchQueue {
    static func background(_ task: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        global(qos: .background).async {
            task?()
            if let completion = completion {
                main.async {
                    completion()
                }
            }
        }
    }
    
    static func userInitiated(_ task: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        global(qos: .userInitiated).async {
            task?()
            if let completion = completion {
                main.async {
                    completion()
                }
            }
        }
    }
}

extension UIImage {
    func blurred(radius: CGFloat, completion: ((UIImage?) -> Void)?) {
        var image: UIImage?
        DispatchQueue.background {
            let ciContext = CIContext(options: nil)
            guard let cgImage = self.cgImage else {
                completion?(nil)
                return
            }
            let inputImage = CIImage(cgImage: cgImage)
            guard let ciFilter = CIFilter(name: "CIGaussianBlur") else {
                completion?(nil)
                return
            }
            ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
            ciFilter.setValue(radius, forKey: "inputRadius")
            guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else {
                completion?(nil)
                return
            }
            guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else {
                completion?(nil)
                return
            }
            image = UIImage(cgImage: cgImage2)
        } completion: {
            completion?(image)
        }
    }
}
