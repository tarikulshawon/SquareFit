//
//  Draw.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 4/2/23.
//

import UIKit

class Draw: UIView {
    var colorArray = [UIColor]()
    
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
    
    
    
    
    @IBAction func onClickBrushWidth(_ sender: UISlider) {
        
    }
    
    
    @IBAction func onClickOpacity(_ sender: UISlider) {
        
    }
    
    @IBAction func onClickClear(_ sender: Any) {
        
    }
    @IBAction func onClickUndo(_ sender: Any) {
        
    }
    
    
}

extension Draw: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  colorArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        print("khanki")
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
    }
    
}
