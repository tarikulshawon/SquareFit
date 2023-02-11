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
    func chnageTexture(index:Int)
    func changeGradient(index:Int)
}

class ColorView: UIView {
    
    
    @IBOutlet weak var colorSegment: UISegmentedControl!
    private var colorWheel: RotatingColorWheel!
    public var delegateForColor: chnageColor?
    var currentBackGroundIndex = 0
    
    @IBOutlet weak var collectionviewF: UICollectionView!
    
    override func draw(_ rect: CGRect) {
        
        
        colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

        colorSegment.selectedSegmentTintColor =  titleColor
        colorSegment.layer.borderWidth = 1.0
        colorSegment.layer.cornerRadius = 5.0
        colorSegment.layer.borderColor = UIColor.white.cgColor
        colorSegment.layer.masksToBounds = true
        
        
        // colorWheel = RotatingColorWheel(frame:  CGRect(x: 0, y: 0, width:self.frame.size.width, height: self.frame.size.height))
        // colorWheel.delegate = self
        // colorWheel.backgroundColor = UIColor.clear
        // self.addSubview(colorWheel)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionviewF.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        
        let path1 = Bundle.main.path(forResource: "gradient", ofType: "plist")
        plistArray1 = NSArray(contentsOfFile: path1!)
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        collectionviewF.reloadData()
        
        collectionviewF.delegate = self
        collectionviewF.dataSource = self
    }
    
    
    
    @IBAction func changeValue(_ sender: UISegmentedControl) {
        
        currentBackGroundIndex = sender.selectedSegmentIndex
        collectionviewF.reloadData()
    }
    
}

extension ColorView: ColorWheelDelegate {
    func didSelect(color: UIColor) {
        delegateForColor?.chnageColorForView(color: color)
    }
}

extension ColorView:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 60, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentBackGroundIndex == 0 {
            return plistArray.count + 2
        }else if currentBackGroundIndex == 1 {
            return plistArray1.count + 1
        }
        
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCell.reusableID,
            for: indexPath) as? ColorCell else {
            return ColorCell()
        }
        
        if currentBackGroundIndex == 0 {
            cell.gradietImv.isHidden = true
            
            if indexPath.row == 0 {
                cell.gradietImv.image = UIImage(named: "ColorPicker")
                cell.gradietImv.isHidden = false
                cell.holderView.backgroundColor = UIColor.clear
            }
            else if indexPath.row == 1 {
                cell.gradietImv.image = UIImage(named: "no-color")
                cell.gradietImv.isHidden = false
                cell.holderView.backgroundColor = UIColor.clear
                
            }
            else if let colorString = plistArray[indexPath.row - 2] as? String {
                cell.holderView.backgroundColor = getColor(colorString: colorString)
                cell.gradietImv.isHidden = true
            }
        }
        
        
        if currentBackGroundIndex == 1 {
            
            if indexPath.row == 0 {
                cell.gradietImv.image = UIImage(named: "no-color")
                cell.gradietImv.isHidden = false
                cell.holderView.backgroundColor = UIColor.clear
                return cell
                
            }
            
            cell.gradietImv.image = nil
            cell.gradietImv.isHidden = false
            if let objArray = plistArray1[indexPath.row - 1] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                cell.gradietImv.contentMode = .scaleAspectFill
                cell.gradietImv.image = uimage
                
                
            }
        }
        
        if currentBackGroundIndex == 2 {
            if indexPath.row == 0 {
                cell.gradietImv.image = UIImage(named: "no-color")
                cell.gradietImv.isHidden = false
                cell.holderView.backgroundColor = UIColor.clear
                return cell
            }
            cell.gradietImv.isHidden = false
            cell.gradietImv.image = UIImage(named: "Texture" + "\(indexPath.row - 1)")
        }
        cell.layer.cornerRadius = cell.frame.height/2.0
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5, animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        
        if currentBackGroundIndex == 0 {
            
            if indexPath.row == 0 {
                
                
            }
            else if indexPath.row == 1 {
                
                delegateForColor?.chnageColorForView(color: UIColor.clear)
            }
            
            else if let colorString = plistArray[indexPath.row - 2] as? String {
                
                delegateForColor?.chnageColorForView(color: getColor(colorString: colorString))
                
            }
            
        }
        if currentBackGroundIndex == 1 {
            if indexPath.row == 0 {
                delegateForColor?.chnageColorForView(color:UIColor.white)
                return
            }
            if let objArray = plistArray1[indexPath.row-1] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 400,height: 400), colors: allcolors)
                delegateForColor?.chnageColorForView(color: UIColor(patternImage: uimage))
                
                
            }
            
        }
        if currentBackGroundIndex == 2 {
            if indexPath.row == 0 {
                delegateForColor?.chnageColorForView(color:UIColor.white)
                return
            }
            let value = UIImage(named: "Texture" + "\(indexPath.row - 1)")!
            delegateForColor?.chnageColorForView(color:UIColor(patternImage: value))
        }
        return
    }
    
}



extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
