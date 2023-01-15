//
//  PhotoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 14/1/23.
//

import UIKit

class PhotoVc: UIViewController {
    
    
    
    @IBOutlet weak var btnCollectionView: UICollectionView!
    var btnArray: NSArray! = nil
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var btnView: UIView!
    let currentlyActiveIndex = 0
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "plist")
        btnArray = NSArray(contentsOfFile: path!)
        initCollectionView()
        self.perform(#selector(self.updateFrame), with: self, afterDelay:0.1)

    }
    
    @objc func updateFrame() {
        let totalCellWidth = cellWidth * CGFloat(btnArray.count)
        let totalSpacingWidth = cellGap * CGFloat((btnArray.count - 1))
        
        let leftInset = (btnCollectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = cellGap
        layout.minimumLineSpacing = cellGap
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnCollectionView?.collectionViewLayout = layout
        
        layout.scrollDirection = .horizontal
        btnCollectionView?.reloadData()
    }
        
    func initCollectionView() {
        let emptyAutomationsCell = RatioCell.nib
        btnCollectionView?.register(emptyAutomationsCell, forCellWithReuseIdentifier: RatioCell.reusableID)
        btnCollectionView.delegate = self
        btnCollectionView.dataSource = self
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension PhotoVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RatioCell.reusableID,
            for: indexPath) as? RatioCell else {
            return RatioCell()
        }
        
        
        cell.iconImv.contentMode = .scaleAspectFit
        cell.iconLabel.textColor = unselectedColor
        cell.heightForLabel.constant = 20.0
        cell.backgroundColor = UIColor.clear
        
        if let value = btnArray[indexPath.row] as? String  {
            
            cell.iconImv.image = UIImage(named: value)?.withRenderingMode(.alwaysTemplate)
            cell.iconImv.tintColor = UIColor.white
            cell.iconLabel.textColor = unselectedColor
            cell.iconLabel.text = value
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return btnArray.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cell = collectionView.cellForItem(at: indexPath) as? RatioCell
        
        if let titleName = cell?.iconLabel.text {
            
            
            let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            
            if titleName.contains("Overlay") {
                vc.defaultHeight = CGFloat(overLayHeight)
                vc.maximumContainerHeight = CGFloat(overLayHeight)
            }
            else {
                vc.defaultHeight = 300
            }
            
            self.present(vc, animated: false)
        }
    }
    
}
