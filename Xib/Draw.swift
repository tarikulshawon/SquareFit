//
//  Draw.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 4/2/23.
//

import UIKit

class Draw: UIView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
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

extension Draw: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  plistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let view = cell.viewWithTag(111) {
            view.layer.cornerRadius = 3
            view.backgroundColor = getColor(colorString: plistArray[indexPath.row] as! String)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = getColor(colorString: plistArray[indexPath.row] as! String)
        
    }
    
}
