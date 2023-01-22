
import UIKit

protocol sendSticker: AnyObject {
    func sendSticker(sticker: String)
}

final class StickerVc: UIView {
    var plistArray6: NSArray!
    weak var delegateForSticker: sendSticker?
    
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    func getStickerArray(indexF: Int) -> NSArray {
        var tempArray: NSArray!
        if let value  = plistArray6[indexF] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            do {
                try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as NSArray
            } catch { }
        }
        
        return tempArray
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        contentsCollectionView.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.showsVerticalScrollIndicator = false
        contentsCollectionView.showsHorizontalScrollIndicator = false
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        contentsCollectionView.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        contentsCollectionView.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderView")
        
        let path = Bundle.main.path(forResource: "sticker", ofType: "plist")
        plistArray6 = NSArray(contentsOfFile: path!)
    }
}


extension StickerVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == contentsCollectionView {
            return plistArray6.count
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
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contentsCollectionView {
            return self.getStickerArray(indexF: section).count
        } else {
            return plistArray6.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == contentsCollectionView {
            return CGSize(width: 80, height: 80)
        } else {
            return CGSize(width: 80, height: 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
            let tempArray = self.getStickerArray(indexF: indexPath.section)
            let filename = tempArray[indexPath.row]
            
            if let value  = plistArray6[indexPath.section] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
                let imagePath = "\(value)/\(filename)"
                let image = UIImage(named: imagePath)
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
        
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentsCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            
            UIView.animate(withDuration: 0.5, animations: {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
                        
            let tempArray = self.getStickerArray(indexF: indexPath.section)
            let filename = tempArray[indexPath.row]
            
            if let value  = plistArray6[indexPath.section] as? String, let _ =  Bundle.main.path(forResource: value, ofType: nil) {
                let imagePath = "\(value)/\(filename)"
                self.delegateForSticker?.sendSticker(sticker: imagePath)
            }
        } else {
            let scrollableSection = IndexPath.init(row: 0, section: indexPath.row)
            contentsCollectionView.scrollToItem(at: scrollableSection, at: .centeredVertically, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == contentsCollectionView {
            return CGSize(width:collectionView.frame.size.width, height:50.0)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == contentsCollectionView {
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


// TODO: Need to fix autoscroll
extension StickerVc {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let indexPaths = categoryCollectionView.indexPathsForSelectedItems,
            !indexPaths.isEmpty
        else {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            categoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            return
        }
        
        if scrollView == self.contentsCollectionView {
            if
                let topSectionIndex = contentsCollectionView.indexPathsForVisibleItems.map({ $0.section }).sorted().first,
                let selectedCollectionIndex = self.categoryCollectionView.indexPathsForSelectedItems?.first?.row,
                selectedCollectionIndex != topSectionIndex {
                let indexPath = IndexPath(item: topSectionIndex, section: 0)
                self.categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
}
