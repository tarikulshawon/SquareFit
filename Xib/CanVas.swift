//
//  CanVas.swift
//  RatioPOC
//
//  Created by Sadiqul Amin on 16/1/23.
//

import UIKit

protocol canvasSend: AnyObject {
    func sendValue(width:Int,height:Int)
}


class CanVas: UIView {
    
    
    weak var delegateForSticker: canvasSend?
    @IBOutlet weak var collectionviewCanvas: UICollectionView!
    var canvasArray:NSArray!
    
    var maxHeight:CGFloat = 0

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = Bundle.main.path(forResource: "style", ofType: "plist")
        canvasArray = NSArray(contentsOfFile: path!)
        getMaxHeight()
        let nibName = UINib(nibName: CanvasRatioCell.reusableID, bundle: nil)
        collectionviewCanvas.register(nibName, forCellWithReuseIdentifier:  CanvasRatioCell.reusableID)
        
        collectionviewCanvas.delegate = self
        collectionviewCanvas.dataSource = self
        
        collectionviewCanvas.showsVerticalScrollIndicator = false
        collectionviewCanvas.showsHorizontalScrollIndicator = false
    }
    func getMaxHeight() {
        
        for item in canvasArray {
            
            var obj = item as? Dictionary<String, Any>
            
            guard  let value = obj?["Width"] as? CGFloat,let value1 = obj?["Height"] as? CGFloat  else {
                return
            }
    
            let height:CGFloat = (value1 * CGFloat(canvasWidth)) / value
            if height > maxHeight {
                maxHeight = height
            }
        }
    }

}

extension CanVas: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: canvasWidth, height: maxHeight + 30)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        canvasArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CanvasRatioCell.reusableID  , for: indexPath as IndexPath) as! CanvasRatioCell
        
        
        var obj = canvasArray[indexPath.row] as? Dictionary<String, Any>
        
        guard  let value = obj?["Width"] as? CGFloat,let value1 = obj?["Height"] as? CGFloat,let name = obj?["Name"] as? String  else  {
            return  cell
        }
        let height:CGFloat = (value1 * CGFloat(canvasWidth)) / value
        
        cell.widthR.constant = CGFloat(canvasWidth)
        cell.heightR.constant = height
        cell.textLabel.textColor = UIColor.white
        cell.textLabel.text = name
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 100, left: 10, bottom: 60, right: 10)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var obj = canvasArray[indexPath.row] as? Dictionary<String, Any>
        
        guard  let value = obj?["Width"] as? CGFloat,let value1 = obj?["Height"] as? CGFloat  else {
            return
        }
        delegateForSticker?.sendValue(width: Int(value), height: Int(value1))
       
    }
    
    
}
