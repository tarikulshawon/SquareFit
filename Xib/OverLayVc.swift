import UIKit

protocol imageIndexDelegate: AnyObject {
    func imageNameWithIndex(tag:String ,image: UIImage?)
    func changeValueForOverlay(value:CGFloat)
}

class OverLayVc: UIView {
    
    public weak var delegateForOverlay: imageIndexDelegate?
    @IBOutlet weak var collectionViewForFilter: UICollectionView!
    
    var centerCell: ColorCell?
    
    func doneLoading(tag: String, successfully: Bool) {
        if successfully {
            guard let image = UIImage(named: "OverLay" + "\(tag)") else { return  }
            delegateForOverlay?.imageNameWithIndex(tag: tag, image: image)
        }
    }
    
  
    @IBAction func sliderValueChnaged(_ sender: UISlider) {
        
        delegateForOverlay?.changeValueForOverlay(value: CGFloat(sender.value))
    }
    
    var noOfFilter  = 49
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        
        collectionViewForFilter.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForFilter.delegate = self
        collectionViewForFilter.dataSource = self
        collectionViewForFilter.showsVerticalScrollIndicator = false
        collectionViewForFilter.showsHorizontalScrollIndicator = false
    }
    
    func setOverLay(index:Int) {
        if let image = UIImage(named: "Overlay" + "\(index)") {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: image)
        }
        else {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: nil)
        }
    }
}

extension OverLayVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { noOfFilter + 1 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        cell.holderView.isHidden = true
        cell.fontLabel.isHidden = true
        
        if indexPath.row == 0 {
            cell.gradietImv.image =  UIImage(named: "nofilter")
        }
        
        else
        {
            
            cell.gradietImv.image =  UIImage(named: "OverlayThumb" + "\(indexPath.row - 1)")
        }
        cell.gradietImv.layer.cornerRadius  = cell.frame.size.height / 2
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(
            withDuration: 0.5,
            animations: {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }) { (true) in
                UIView.animate(withDuration: 0.5) {
                    cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        
        setOverLay(index: indexPath.row - 1)
    }
}
