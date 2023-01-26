import UIKit

protocol filterIndexDelegate: AnyObject {
    func filterNameWithIndex(dic: Dictionary<String, Any>?)
}

class FilterVc: UIView {
    func doneLoading(tag: String, successfully: Bool) {
        
    }
    
    var tempArray:NSArray!
    
    weak var delegateForFilter: filterIndexDelegate?
    
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var contentsCollectionView: UICollectionView!
    
    var filterName = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        
        contentsCollectionView.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.showsVerticalScrollIndicator = false
        contentsCollectionView.showsHorizontalScrollIndicator = false
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let path = Bundle.main.path(forResource: "FilterGroup", ofType: "plist")
        fliterArray = NSArray(contentsOfFile: path!)
        filterName.removeAll()
        
        categoryCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        contentsCollectionView.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        contentsCollectionView.register(UINib.init(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HeaderView")
        
        
        for item in fliterArray {
            let obj = item as? Dictionary<String, Any>
            
            if let v = obj?["group-name"]  as? String{
                filterName.append(v)
            }
        }
    }
}


extension FilterVc: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView == contentsCollectionView ? fliterArray.count : 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contentsCollectionView {
            if let value = fliterArray[section] as? Dictionary<String, Any>{
                tempArray  = value["items"] as! NSArray
                return tempArray.count
            }
            
            return 0
        } else {
            return fliterArray.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == contentsCollectionView {
            return CGSize(width: 80, height: 80)
        } else {
            return CGSize(width: 80, height: 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
            cell.holderView.isHidden = true
            cell.fontLabel.isHidden = true
            if indexPath.row == 0 {
                cell.gradietImv.image =  UIImage(named: "nofilter")
            }
            else {
                cell.gradietImv.image =  UIImage(named: "filterg")
                
                if let value = fliterArray[indexPath.section] as? Dictionary<String, Any>{
                    let tempArray  = value["items"] as! NSArray
                    var dic = tempArray[indexPath.row]
                    let image  = getFilteredImage(withInfo: dic as! [String : Any], for: UIImage(named: "filterg"))
                    cell.gradietImv.image  = image
                    
                }
                
            }
            cell.layer.cornerRadius = cell.frame.size.height/2.0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
            
            if let value = fliterArray[indexPath.row] as? Dictionary<String, Any>{
                let name = value["group-name"] as? String
                cell.prepare(with: name ?? "")
            }
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentsCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath)
            
            UIView.animate(withDuration: 0.5, animations:
                            {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations:
                                {
                    cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
            
            if indexPath.row == 0 {
                delegateForFilter?.filterNameWithIndex(dic: nil)
            }
            else  {
                if let value = fliterArray[indexPath.section] as? Dictionary<String, Any>{
                    let tempArray  = value["items"] as! NSArray
                    var dic = tempArray[indexPath.row]
                    delegateForFilter?.filterNameWithIndex(dic: dic as! Dictionary<String, Any>)
                    
                }
            }
        } else {
            let scrollableSection = IndexPath.init(row: 0, section: indexPath.row)
            contentsCollectionView.scrollToItem(at: scrollableSection, at: .centeredVertically, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == contentsCollectionView {
            return CGSize(width:collectionView.frame.size.width, height: 50.0)
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
                if let value  = filterName[indexPath.section] as? String {
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

extension FilterVc {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let indexPaths = categoryCollectionView.indexPathsForSelectedItems,
            !indexPaths.isEmpty
        else {
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            categoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
            return
        }
        
        if scrollView == self.contentsCollectionView && contentsCollectionView.isDragging {
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
