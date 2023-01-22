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
    
    var plistArray6: NSArray!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    let buttonWidth:CGFloat = 80.0
    let gapBetweenButtons: CGFloat = 7
    var resourcePath2:String?
    var currentSelectedSticker = 0
    weak var delegateForSticker: sendSticker?
    private var autoScrollEnabled = true
    
    @IBOutlet weak var collectionViewForSticker: UICollectionView!
    @IBOutlet weak var btnScrollView: UICollectionView!
    
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
        
        btnScrollView.delegate = self
        btnScrollView.dataSource = self
        
        btnScrollView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        collectionViewForSticker.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        collectionViewForSticker.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderView")
        
        
        
        let path = Bundle.main.path(forResource: "sticker", ofType: "plist")
        plistArray6 = NSArray(contentsOfFile: path!)
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
           // self.collectionViewForSticker.reloadData()
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
}


extension StickerVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewForSticker {
            return  plistArray6.count
        } else {
            return 1
        }
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
        if collectionView == collectionViewForSticker {
            return self.getStickerArray(indexF: section).count
        } else {
            return plistArray6.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if collectionView == collectionViewForSticker {
            return CGSize(width: 80, height: 80)
        } else {
            return CGSize(width: 80, height: 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewForSticker {
            
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
            let name = plistArray6[indexPath.row] as? String
            cell.prepare(with: name ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewForSticker {
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
            
            print("section: \(indexPath.section)")
            
            let tempArray = self.getStickerArray(indexF: indexPath.section)
            let filename = tempArray[indexPath.row]
            
            if let value  = plistArray6[currentSelectedSticker] as? String, let _ =  Bundle.main.path(forResource: value, ofType: nil) {
                let imagePath = "\(value)/\(filename)"
                self.delegateForSticker?.sendSticker(sticker: imagePath)
            }
        } else {
            let scrollableSection = IndexPath.init(row: 0, section: indexPath.row)
            collectionViewForSticker.scrollToItem(at: scrollableSection, at: .centeredVertically, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionViewForSticker {
            return CGSize(width:collectionView.frame.size.width, height:50.0)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == collectionViewForSticker {
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
        } else {
            return UICollectionReusableView()
        }
   }
}

extension StickerVc {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let indexPaths = btnScrollView.indexPathsForSelectedItems,
            !indexPaths.isEmpty
        else {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            btnScrollView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            return
        }
        
        if scrollView == self.collectionViewForSticker {
            if
                let topSectionIndex = collectionViewForSticker.indexPathsForVisibleItems.map({ $0.section }).sorted().first,
                let selectedCollectionIndex = self.btnScrollView.indexPathsForSelectedItems?.first?.row,
                selectedCollectionIndex != topSectionIndex {
                print("top: \(topSectionIndex), selected: \(selectedCollectionIndex))")
                let indexPath = IndexPath(item: topSectionIndex, section: 0)
                self.btnScrollView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
}
