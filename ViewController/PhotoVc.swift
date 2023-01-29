//
//  PhotoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 14/1/23.
//

import UIKit
import AudioToolbox

class PhotoVc: UIViewController, allDelegate, UIGestureRecognizerDelegate, StickerViewDelegate, changeImage, backButton, TextStickerContainerViewDelegate {
    
    
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView) {
         
    }
    
    func editTextStickerView(textStickerContainerView: TextStickerContainerView) {
         
    }
    
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView) {
         
    }
    
    func moveViewPosition(textStickerContainerView: TextStickerContainerView) {
         
    }
    
    func showKeyBoard(text: String) {
         
    }
    
    
    func sendShapeValue(sticker: String) {
        self.addSticker(test: UIImage(named: sticker)!)
    }
    
    
    func sendOverLayValue(value: CGFloat) {
        overlayView.alpha = value
        
    }
    
    func doneBack() {
        
    }
    
    func changeImage(image: UIImage) {
        
    }
    
    func sendFilter(dic: Dictionary<String, Any>?) {
        
        let img = selectedImage //UIImage(named: "lol.jpg")
        
        
        if dic == nil {
            imv.image = img
            return
        }
        imv.image = getFilteredImage(withInfo: dic as! [String : Any], for: img)
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
         
    }
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        
    }
    
    func sendAdjust(value: Float, index: Int) {
        
    }
    
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var center_horizontal_img_view: UIImageView!
    @IBOutlet weak var center_vertical_img_view: UIImageView!
    var currentTextStickerView: TextStickerContainerView?
    
    func sendFrame(frames: String) {
        let v = UIImage(named: frames)
        frameVc.image = v
        
    }
    
    func sendOverLay(image: UIImage?) {
        if image?.size.width ?? 0 > 0 {
            overlayView.image = image
            overlayView.isHidden = false
        }
        else {
            overlayView.isHidden = true
        }
    }
    
    
    @IBOutlet weak var stickerView: UIView!
    
    @IBOutlet weak var intermediateview: UIView!
    
    @IBOutlet weak var frameVc: UIImageView!
    
    func sendCanvasData(width: Int, height: Int) {
       
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
        
        addSticker(test: UIImage(named: sticker)!)
        
    }
    
    
    func addText(text: String, font: UIFont) {
        print("[AddText] delegate called")
       
        let frame = CGRect(x: 0, y: 0, width: 250, height: 200)
        let sticker = TextStickerContainerView(frame: frame)
        sticker.tag = -1// TODO: implement in alternative way
        sticker.delegate = self
        sticker.currentFontIndex = -1
        
        sticker.pathName = font.fontName //
        sticker.pathType = "TEXT"
        
        //sticker.textStickerView.delegate = self
        sticker.textStickerView.text = text
        sticker.textStickerView.font = font
        
        sticker.textStickerView.updateTextFont()
        sticker.initilizeTextStickerData(mainTextView: sticker.textStickerView)
        
        stickerView.addSubview(sticker)
        stickerView.clipsToBounds = true
        currentTextStickerView = sticker
        
        guard let textStickerView = currentTextStickerView else {
            print("[EditVC] currentTextStickerView is nill")
            return
        }
        
        textStickerView.deleteController.isHidden = false
        textStickerView.scaleController.isHidden = false
        textStickerView.extendBarView.isHidden = false
        textStickerView.hideTextBorder(isHide: false)
    }
    
    
    func addSticker(test: UIImage) {
        let testImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        testImage.image = test
        let stickerView3 = StickerView.init(contentView: testImage)
        stickerView3.backgroundColor = UIColor.clear
        stickerView3.center = CGPoint.init(x: 50, y: 50)
        stickerView3.delegate = self
        stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
        stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
        stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
        stickerView3.showEditingHandlers = false
        stickerView3.tag = -1
        stickerView.addSubview(stickerView3)
        stickerView.clipsToBounds = true
        stickerView3.showEditingHandlers = true
        stickerView3.showEditingHandlers = true
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
    var selectedImage: UIImage? = nil
    
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
            
            if (((imv.center.x >= (intermediateview.frame.size.width/2.0 - 2)) &&
                 (imv.center.x <= (intermediateview.frame.size.width/2.0 + 2))))
            {
                center_vertical_img_view.isHidden = false
                makeHepticFeedback()
            }
            else {
                center_vertical_img_view.isHidden = true
            }
            
            if (((imv.center.y >= (intermediateview.frame.size.width/2.0 - 2)) &&
                 (imv.center.y <= (intermediateview.frame.size.width/2.0 + 2))))
            {
                center_horizontal_img_view.isHidden = false
                makeHepticFeedback()
            }
            else {
                center_horizontal_img_view.isHidden = true
            }
        }
        
        else if (recogniser.state == .ended) {
           
            center_vertical_img_view.isHidden = true
            center_horizontal_img_view.isHidden = true
        }
    }
    
    private func makeHepticFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    
    @objc private func didPinch(_ recogniser: UIPinchGestureRecognizer) {
        
        
        imv.transform = CGAffineTransformScale(imv.transform, recogniser.scale * 1, recogniser.scale * 1);
        recogniser.scale = 1;
        
    }
    
    @objc private func didTap(_ recogniser: UITapGestureRecognizer) {
        
        
    }
    
    @objc func updateFrame() {
        widthForTempView.constant = holderView.frame.width
        heightForTempView.constant = holderView.frame.width
        imv.image = selectedImage //UIImage(named: "lol.jpg")
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
            vc.canVas.isHidden = true
            vc.stickerVc.isHidden = true
            vc.overlayVc.isHidden = true
            vc.shapeVc.isHidden = true
            vc.frameVc.isHidden = true
            vc.adjustVc.isHidden = true
            vc.filterVc.isHidden = true
            vc.imageEditVc.isHidden = true
            
            
            if titleName.contains("Texts") {
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "keyboard") as? keyboard
                vc?.delegateForChnageImage = self
                vc?.delegateForBack = self
                let navController = UINavigationController(rootViewController: vc!)
                navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                present(navController, animated: true, completion: nil)
                return
            }
            
            
            else if titleName.contains("Image") {
                vc.defaultHeight = CGFloat(adjustHeight)
                vc.maximumContainerHeight = CGFloat(adjustHeight)
                vc.imageEditVc.isHidden = false
            }
            
            else if titleName.contains("Adjust") {
                vc.defaultHeight = CGFloat(adjustHeight)
                vc.maximumContainerHeight = CGFloat(adjustHeight)
                vc.adjustVc.isHidden = false
            }
            
            else if titleName.contains("Frames") {
                vc.defaultHeight = CGFloat(framesVcHeight)
                vc.frameVc.isHidden = false
            }
            
            else if titleName.contains("Canvas") {
                vc.defaultHeight = CGFloat(canVasHeight)
                vc.maximumContainerHeight  = CGFloat(canVasHeight)
                vc.canVas.isHidden = false
            }
            
            else if titleName.contains("Overlay") {
                vc.defaultHeight = CGFloat(overLayHeight)
               // vc.maximumContainerHeight = CGFloat(overLayHeight)
                vc.overlayVc.isHidden = false
                
               
            }
            else if titleName.contains("Shape") {
                vc.defaultHeight = CGFloat(shapeVcHeight)
                vc.maximumContainerHeight = CGFloat(shapeVcHeight)
                vc.shapeVc.isHidden = false
                
            }
            else if titleName.contains("Filter") {
                vc.defaultHeight = CGFloat(filterHeight)
                vc.filterVc.isHidden = false
                
            }
            else if titleName.contains("Quotes") {
                let storyboard: UIStoryboard = UIStoryboard(name: "QuotesStoryBoard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "QuotesStoryBoard") as! QuotesViewController
                
                vc.delegateForQuotes = self
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = UIModalPresentationStyle.popover
                present(navController, animated: true, completion: nil)
                return
            }
            else if titleName.contains("BackGround") {
                vc.defaultHeight = 300
                vc.backGroundView.isHidden = false
                
            }
            else {
                vc.defaultHeight = 300
                vc.stickerVc.isHidden = false

            }
            vc.typeName = titleName
            
            presentSheetViewController(with: vc, initialHeight: vc.defaultHeight, maxHeight: vc.maximumContainerHeight)
        }
    }
    
}

extension PhotoVc: quotesDelegate {
    func sendQuoteText(text: String) {
        self.addText(text: text, font: UIFont.systemFont(ofSize: 20.0))
    }
}

private extension PhotoVc {
    func presentSheetViewController(with vc: UIViewController, initialHeight: CGFloat, maxHeight: CGFloat) {
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .init("\(initialHeight)") ,resolver: { _ in initialHeight }),
                .medium(),
                .custom(identifier: .init("\(maxHeight)") ,resolver: { _ in maxHeight })
            ]
            
            sheet.selectedDetentIdentifier = .none
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated: true, completion: nil)
    }
}


extension UITextView {
    
func setCharacterSpacing(_ spacing: CGFloat){
    let attributedStr = NSMutableAttributedString(string: self.text ?? "")
    attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
    self.attributedText = attributedStr
 }
    
    func updateTextFont() {
        if text.isEmpty || bounds.size.equalTo(CGSize.zero) { return }
        
        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont
        }
    }
}
