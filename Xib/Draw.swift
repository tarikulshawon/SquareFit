//
//  Draw.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 4/2/23.
//

import UIKit

protocol drawViewDelegate: AnyObject {
    func sendBrushWidth(value: CGFloat)
    func sendOpacity(value:CGFloat)
    func undoAction()
    func sendColor(color:UIColor)
    func clearAllData()
}

class Draw: UIView {
    var colorArray = [UIColor]()
    
    weak var delegateForDraw: drawViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource  = self
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        colorArray.append(UIColor.white)
        colorArray.append(UIColor.black)
        
        for item in plistArray {
            colorArray.append(getColor(colorString: item as! String))
        }
        
    }
    
    
    
    @IBAction func undoAction(_ sender: Any) {
        
        delegateForDraw?.undoAction()
    }
    
    @IBAction func onClickBrushWidth(_ sender: UISlider) {
        delegateForDraw?.sendBrushWidth(value: CGFloat(sender.value))
        
    }
    
    
    @IBAction func onClickOpacity(_ sender: UISlider) {
        delegateForDraw?.sendOpacity(value: CGFloat(sender.value))
        
    }
    
    @IBAction func onClickClear(_ sender: Any) {
        delegateForDraw?.clearAllData()
        
    }
    @IBAction func onClickUndo(_ sender: Any) {
        
    }
    
    
}

extension Draw: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        cell.backgroundColor = colorArray[indexPath.row]
        cell.layer.cornerRadius = cell.frame.width / 2.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateForDraw?.sendColor(color: colorArray[indexPath.row])
        
    }
    
}
