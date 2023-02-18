//
//  ColorView.swift
//  CustomKeyBoard
//
//  Created by MacBook Pro Retina on 23/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit
import Combine


protocol chnageColor {
    func chnageColorForView(color: UIColor,index:Int)
    func chnageTexture(index:Int)
    func changeGradient(index:Int)
}

class ColorView: UIView {
    
   
    var cancellable: AnyCancellable?

    @IBOutlet weak var colorSegment: UISegmentedControl!
    private var colorWheel: RotatingColorWheel!
    public var delegateForColor: chnageColor?
    var currentBackGroundIndex = 0
    
    @IBOutlet weak var collectionviewF: UICollectionView!
    var currenIndex = 0
    
    @IBAction func BackgroundOrTextChange(_ sender: UISegmentedControl) {
        currenIndex = sender.selectedSegmentIndex
    
    }
    
    
    @IBOutlet weak var textBG: UISegmentedControl!
    override func draw(_ rect: CGRect) {
        
        
        colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        colorSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

        colorSegment.selectedSegmentTintColor =  titleColor
        colorSegment.layer.borderWidth = 1.0
        colorSegment.layer.cornerRadius = 5.0
        colorSegment.layer.borderColor = UIColor.white.cgColor
        colorSegment.layer.masksToBounds = true
        
        
        textBG.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        textBG.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

        textBG.selectedSegmentTintColor =  titleColor
        textBG.layer.borderWidth = 1.0
        textBG.layer.cornerRadius = 5.0
        textBG.layer.borderColor = UIColor.white.cgColor
        textBG.layer.masksToBounds = true
        
        
        
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
        delegateForColor?.chnageColorForView(color: color, index: 0)
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
                
                
                let picker = UIColorPickerViewController()
                self.cancellable = picker.publisher(for: \.selectedColor)
                    .sink { color in
                        
                        //  Changing view color on main thread.
                        DispatchQueue.main.async {
                            
                        }
                    }
                
                
                if let sheet = picker.sheetPresentationController {
                    
                    sheet.detents = [.medium()]
                    sheet.largestUndimmedDetentIdentifier = .large
                    sheet.selectedDetentIdentifier = .none
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                }
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
            
                keyWindow?.rootViewController?.visibleViewController!.present(picker, animated: true, completion: nil)
        }
            else if indexPath.row == 1 {
                
                delegateForColor?.chnageColorForView(color: UIColor.clear, index: currenIndex)
            }
            
            else if let colorString = plistArray[indexPath.row - 2] as? String {
                
                delegateForColor?.chnageColorForView(color: getColor(colorString: colorString), index: currenIndex)
                
            }
            
        }
        if currentBackGroundIndex == 1 {
            if indexPath.row == 0 {
                delegateForColor?.chnageColorForView(color:UIColor.white, index: currenIndex)
                return
            }
            if let objArray = plistArray1[indexPath.row-1] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 400,height: 400), colors: allcolors)
                delegateForColor?.chnageColorForView(color: UIColor(patternImage: uimage), index: currenIndex)
                
                
            }
            
        }
        if currentBackGroundIndex == 2 {
            if indexPath.row == 0 {
                delegateForColor?.chnageColorForView(color:UIColor.white, index: currenIndex)
                return
            }
            let value = UIImage(named: "Texture" + "\(indexPath.row - 1)")!
            delegateForColor?.chnageColorForView(color:UIColor(patternImage: value), index: currenIndex)
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


extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}
