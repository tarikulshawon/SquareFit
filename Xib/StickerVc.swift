//
//  StickerVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol sendSticker: AnyObject {
    func sendSticker(sticker:String)
}


class StickerVc: UIView {
    
    var plistArray6:NSArray!
    @IBOutlet weak var optionView: UIView!
    var btnScrollView: UIScrollView!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    let buttonWidth:CGFloat = 80.0
    let gapBetweenButtons: CGFloat = 7
    var resourcePath2:String?
    var currentSelectedSticker = 0
    weak var delegateForSticker: sendSticker?
    
    @IBOutlet weak var collectionViewForSticker: UICollectionView!
    
    
    func getStickerArray(indexF: Int) -> NSArray {
        var tempArray:NSArray!
        if let value  = plistArray6[indexF] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            
            do {
                try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as NSArray
            } catch {
            }
            
        }
        
        return tempArray
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        collectionViewForSticker.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        collectionViewForSticker.delegate = self
        collectionViewForSticker.dataSource = self
        collectionViewForSticker.showsVerticalScrollIndicator = false
        collectionViewForSticker.showsHorizontalScrollIndicator = false
        
        
        collectionViewForSticker.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        collectionViewForSticker.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderView")
        
        
        
        let path = Bundle.main.path(forResource: "sticker", ofType: "plist")
        plistArray6 = NSArray(contentsOfFile: path!)
        stickersScrollContents()
        
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let tag = sender.tag - 800
        currentSelectedSticker = tag
        getStickerArray(indexF: currentSelectedSticker)
        
        for i in 0..<self.plistArray6.count{
            var btn = self.btnScrollView.viewWithTag(i+800) as? UIButton
            btn?.setTitleColor(unselectedColor, for: .normal)
        }
        
        
        DispatchQueue.main.async {
            self.collectionViewForSticker.reloadData()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            var value = CGFloat (sender.tag)
            sender?.setTitleColor(UIColor.white, for: .normal)
            var frame = self.selectedIndexView.frame
            frame.origin.x = sender.frame.origin.x
            self.selectedIndexView.frame = frame
            self.layoutIfNeeded()
            
        }, completion: {_ in
            
            
            var btn = self.btnScrollView.viewWithTag(sender.tag) as? UIButton
            btn?.setTitleColor(UIColor.white, for: .normal)
            
            
            
            
        })
        
    }
    
    func stickersScrollContents() {
        
        print("mammamamama")
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 0
        let buttonHeight: CGFloat = 45.0
        let tempBtn:CGFloat = 25.0
        btnScrollView = UIScrollView(frame: CGRect(x: 8, y: 0, width: optionView.frame.width, height: optionView.frame.height))
        //btnScrollView.backgroundColor = UIColor.red
        
        optionView.addSubview(btnScrollView)
        tempViww = UIView(frame: CGRect(x: 0, y: (buttonHeight - tempBtn)/2.0, width: buttonWidth, height: tempBtn))
        selectedIndexView = UIView(frame: CGRect(x: xCoord, y: 0, width: buttonWidth, height: buttonHeight))
        selectedIndexView.addSubview(tempViww)
        tempViww.backgroundColor = tintColor
        tempViww.layer.cornerRadius = tempViww.frame.size.height / 2.0
        //selectedIndexView.backgroundColor = UIColor.clear
        
        
        btnScrollView.addSubview(selectedIndexView)
        btnScrollView.showsHorizontalScrollIndicator = false
        btnScrollView.showsVerticalScrollIndicator = false
        
        
        for i in 0..<plistArray6.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 800 + i
            filterButton.backgroundColor = UIColor.clear
            
            if i == 0 {
                tempViww.backgroundColor = titleColor
            }
            
            if let value = plistArray6[i] as? String{
                filterButton.setTitle(value, for: .normal)
                filterButton.setTitleColor(unselectedColor, for: .normal)
            }
            
            filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            if i == 0 {
                filterButton.setTitleColor(UIColor.white, for: .normal)
            }
            //filterButton.setTitleColor(tintColor, for: .normal)
            filterButton.clipsToBounds = true
            filterButton.backgroundColor = UIColor.clear
            xCoord +=  buttonWidth + gapBetweenButtons
            filterButton.titleLabel?.textAlignment = .center
            btnScrollView.addSubview(filterButton)
            
        }
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(plistArray6.count) + gapBetweenButtons * CGFloat((plistArray6.count*2 + 1)), height: yCoord)
        
    }
    
    
}


extension StickerVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  plistArray6.count
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.getStickerArray(indexF: section).count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 80, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        
        
        var tempArray = self.getStickerArray(indexF: indexPath.section)
        let filename = tempArray[indexPath.row]
        
        
        if let value  = plistArray6[indexPath.section] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            let imagePath = "\(value)/\(filename)"
            var image = UIImage(named: imagePath)
            cell.mainImv.image = image
            
        }
        
        cell.iconImv.backgroundColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        cell.heightForLabel.constant = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5, animations:
                        {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            //cell?.backgroundColor = UIColor.lightGray
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations:
                            {
                cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0);                //cell?.backgroundColor = UIColor.clear
            })
        }
        
        
        let tempArray = self.getStickerArray(indexF: indexPath.section)
        let filename = tempArray[indexPath.row]
        
        if let value  = plistArray6[currentSelectedSticker] as? String, let _ =  Bundle.main.path(forResource: value, ofType: nil) {
            let imagePath = "\(value)/\(filename)"
            self.delegateForSticker?.sendSticker(sticker: imagePath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:50.0)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {

       switch kind {

       case UICollectionView.elementKindSectionHeader:
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath) as? HeaderView
           if let value  = plistArray6[indexPath.section] as? String {
               headerView?.lbl.text = value
               headerView?.lbl.textColor = titleColor
           }
           return headerView!

       case UICollectionView.elementKindSectionFooter:
           let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath)
           footerView.backgroundColor = UIColor.black
           return footerView

       default:
           assert(false, "Unexpected element kind")
       }
   }
    
    
}
