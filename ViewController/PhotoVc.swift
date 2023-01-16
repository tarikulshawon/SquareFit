//
//  PhotoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 14/1/23.
//

import UIKit

class PhotoVc: UIViewController, allDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var intermediateview: UIView!
    
    
    func sendCanvasData(width: Int, height: Int) {
        imv.image = nil
        imv.image = UIImage(named: "bg")
        let result = CGFloat(height*Int(holderView.frame.width))/CGFloat(width)
        UIView.animate(withDuration: 0.4, animations: {
            
            if result > self.holderView.frame.height {
                let result1 = CGFloat(width*Int(self.holderView.frame.height))/CGFloat(height)
                self.widthForTempView.constant = result1
                self.heightForTempView.constant =  self.holderView.frame.height
                
            } else {
                
                self.widthForTempView.constant = self.holderView.frame.width
                self.heightForTempView.constant =  result
            }
            
            self.view.layoutIfNeeded()
             
        }) { _ in
            
        }
    }
    
    func stickerData(sticker: String) {
        
    }
    
    
    
    
    @IBOutlet weak var widthForTempView: NSLayoutConstraint!
    @IBOutlet weak var heightForTempView: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnCollectionView: UICollectionView!
    var btnArray: NSArray! = nil
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var btnView: UIView!
    let currentlyActiveIndex = 0
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0
    
    var panRecogniser:UIPanGestureRecognizer! = nil
    var pinchRecogniser:UIPinchGestureRecognizer! = nil
    var tapRecogniser: UITapGestureRecognizer! =  nil
    

    @IBOutlet weak var imv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pinchRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        
        intermediateview.addGestureRecognizer(panRecogniser)
        intermediateview.addGestureRecognizer(pinchRecogniser)
        intermediateview.addGestureRecognizer(tapRecogniser)
        
        panRecogniser.delegate = self
        pinchRecogniser.delegate = self
        tapRecogniser.delegate = self
        
        
        let path = Bundle.main.path(forResource: "btn", ofType: "plist")
        btnArray = NSArray(contentsOfFile: path!)
        initCollectionView()
        self.perform(#selector(self.updateFrame), with: self, afterDelay:0.1)
       

    }
    
    @objc private func didPan(_ recogniser: UIPanGestureRecognizer) {
        
        if recogniser.state == .began || recogniser.state == .changed {
            let panTranslation = recogniser.translation(in: imv.superview)
            let translatedCenter = CGPoint(x: imv.center.x + panTranslation.x, y: imv.center.y + panTranslation.y)
            imv.center = translatedCenter
            recogniser.setTranslation(.zero, in: imv)
        }
    }
    
    
    @objc private func didPinch(_ recogniser: UIPinchGestureRecognizer) {
        
    
        
        imv.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        imv.transform = CGAffineTransform(scaleX: recogniser.scale * CGFloat(1), y: recogniser.scale * CGFloat(1))
        
    }
    
    @objc private func didTap(_ recogniser: UITapGestureRecognizer) {
        
        
    }
    
    @objc func updateFrame() {
        
        widthForTempView.constant = holderView.frame.width
        heightForTempView.constant = holderView.frame.width
        imv.image = UIImage(named: "bg")
        imv.contentMode = .scaleAspectFit
        
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
            vc.delegateForEditedView = self
            vc.modalPresentationStyle = .overCurrentContext
            vc.canVas.isHidden = true
            vc.stickerVc.isHidden = true
            vc.overlayVc.isHidden = true
            
            if titleName.contains("Canvas") {
                vc.defaultHeight = CGFloat(canVasHeight)
                vc.maximumContainerHeight  = CGFloat(canVasHeight)
                vc.canVas.isHidden = false
            }
            
            else if titleName.contains("Overlay") {
                vc.defaultHeight = CGFloat(overLayHeight)
               // vc.maximumContainerHeight = CGFloat(overLayHeight)
                vc.overlayVc.isHidden = false
                
               
            }
            else {
                vc.defaultHeight = 300
                vc.stickerVc.isHidden = false

            }
            vc.typeName = titleName
            
            self.present(vc, animated: false)
        }
    }
    
}
