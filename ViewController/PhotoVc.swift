//
//  PhotoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 14/1/23.
//

import UIKit
import AudioToolbox
import Mantis

class PhotoVc: UIViewController, allDelegate, UIGestureRecognizerDelegate, StickerViewDelegate, changeImage, backButton, TextStickerContainerViewDelegate, CropViewControllerDelegate {
    
    @IBOutlet weak var widthForTempView: NSLayoutConstraint!
    @IBOutlet weak var heightForTempView: NSLayoutConstraint!
    @IBOutlet weak var btnCollectionView: UICollectionView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var center_horizontal_img_view: UIImageView!
    @IBOutlet weak var center_vertical_img_view: UIImageView!
    @IBOutlet weak var backgroundImv: UIImageView!
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var intermediateview: UIView!
    @IBOutlet weak var frameVc: UIImageView!
    var selectedImage: UIImage? = nil
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0
    var panRecogniser:UIPanGestureRecognizer! = nil
    var pinchRecogniser:UIPinchGestureRecognizer! = nil
    var tapRecogniser: UITapGestureRecognizer! =  nil
    var btnArray: NSArray! = nil
    var currentTextStickerView: TextStickerContainerView?
    let currentlyActiveIndex = 0
    
    var Brightness: Float = 0.0
    var max_brightness:Float = 0.7
    var min_brightness:Float = -0.7
    
    var Saturation: Float = 1.0
    var max_saturation:Float = 3
    var min_saturation:Float = -1
    
    var hue: Float = 0.0
    var max_hue:Float = 1.0
    var min_hue:Float = -1.0
    
    var Contrast: Float = 1.0
    var max_contrast:Float = 1.5
    var min_contrast:Float = 0.5
    
    var sharpen:Float = 0
    var max_sharpen:Float = 4.0
    var min_sharpen:Float = -4.0
    
    var currentFilterDic:Dictionary<String, Any>? = nil
    
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        imv.image = cropped
        cropViewController.dismiss(animated: true)
        
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
        
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        
    }
    
    func cropViewControllerDidImageTransformed(_ cropViewController: Mantis.CropViewController) {
        
    }
    
    func sendOpacityValue(value: CGFloat) {
        drawView.strokeOpacity = value
    }
    
    func clearAllDataValue() {
        drawView.clearCanvasView()
    }
    
    
    func sendBrushWidthValue(value: CGFloat) {
        drawView.strokeWidth =  value
    }
    
    func shouldHideDraw() {
        drawView.isUserInteractionEnabled = false
    }
    
    
    
    func sendColorValue(color: UIColor) {
        drawView.strokeColor = color
    }
    
    
    
    func undoValue() {
        drawView.undoDraw()
    }
    
    
    
    func changeTextView(obj: TextEdit,isFromUpdate:Bool) {
        
        if isFromUpdate {
            
            currentTextStickerView?.textStickerView.fontSize = obj.fontSize
            currentTextStickerView?.textStickerView.textColor = obj.fontColor
            currentTextStickerView?.textStickerView.autocorrectionType = .no
            currentTextStickerView?.textStickerView.backgroundColor = obj.textBackGroundColor
            currentTextStickerView?.textStickerView.layer.shadowColor = obj.shadowColor
            
            if obj.shadowRadius != -1 {
                currentTextStickerView?.textStickerView.layer.shadowRadius = obj.shadowRadius
            }
            
            if obj.shadowOpacity != -1 {
                currentTextStickerView?.textStickerView.layer.shadowOpacity = Float(obj.shadowOpacity)
            }
            
            if obj.shadowOffset.width > 0 {
                currentTextStickerView?.textStickerView.layer.shadowOffset = obj.shadowOffset
            }
            
            
            if obj.fontName.count > 0 {
                currentTextStickerView?.textStickerView.font = UIFont(name: obj.fontName, size: obj.fontSize)
            }
            else {
                currentTextStickerView?.textStickerView.font = UIFont.systemFont(ofSize: obj.fontSize)
            }
            
            currentTextStickerView?.textStickerView.textAlignment = obj.aigment
            
            currentTextStickerView?.textStickerView.alpha = obj.textOpacity
            currentTextStickerView?.textStickerView.backgroundColor = obj.textBackGroundColor
            currentTextStickerView?.textStickerView.text = obj.text
            currentTextStickerView?.scaleController.updateFrame()
            
        }
        else {
            self.addText(obj: obj)
        }
        
        
    }
    
    
    
    
    func showKeyBoard(container: TextStickerView) {
        
        let x = container.fontSize
        let y = container.font?.fontName
        let z = container.textColor
        let l = container.backgroundColor
        let m = container.layer.shadowColor
        
        print(x)
        print(y)
        print(z)
        print(l)
        print(m)
        
        if let a  = container.fontSize,
           let b = container.font?.fontName ,
           let c = container.textColor,
           let d = container.backgroundColor,
           let e = container.layer.shadowColor{
            
            let obj = TextEdit()
            obj.fontSize = a
            obj.fontName = b
            obj.fontColor = c
            obj.textBackGroundColor = d
            obj.shadowColor = e
            obj.shadowOffset = container.layer.shadowOffset
            obj.shadowOpacity = Double(container.layer.shadowOpacity)
            obj.shadowRadius = container.layer.shadowRadius
            obj.textOpacity = container.alpha
            obj.text = container.text
            obj.textBackGroundColor = container.backgroundColor ?? UIColor.clear
            obj.aigment = container.textAlignment
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "keyboard") as? keyboard
            vc?.delegateForChnageImage = self
            vc?.delegateForBack = self
            vc?.texeditObj = obj
            let navController = UINavigationController(rootViewController: vc!)
            navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            present(navController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    @IBOutlet weak var drawView: DrawingView!
    
   
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawView.clipsToBounds = true
        drawView.isUserInteractionEnabled = false
        
        panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pinchRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        
        intermediateview.addGestureRecognizer(panRecogniser)
        intermediateview.addGestureRecognizer(pinchRecogniser)
        stickerView.addGestureRecognizer(tapRecogniser)
        
        panRecogniser.delegate = self
        pinchRecogniser.delegate = self
        tapRecogniser.delegate = self
        
        
        let path = Bundle.main.path(forResource: "btn", ofType: "plist")
        btnArray = NSArray(contentsOfFile: path!)
        initCollectionView()
        self.perform(#selector(self.updateFrame), with: self, afterDelay:0.1)
        
    }
    
    func sendColorBackgroundV(color: UIColor, image: UIImage?) {
        
        if let value = image {
            backgroundImv.image = value
        }
        else {
            backgroundImv.image = nil
            backgroundImv.backgroundColor = color
        }
    }
    
    
    
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView) {
        self.hideALL()
        self.currentTextStickerView = textStickerContainerView
        self.currentTextStickerView?.hideTextBorder(isHide: false)
    }
    
    func editTextStickerView(textStickerContainerView: TextStickerContainerView) {
        
    }
    
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView) {
        currentTextStickerView?.removeFromSuperview()
        
    }
    
    func moveViewPosition(textStickerContainerView: TextStickerContainerView) {
        
    }
    
    func showKeyBoard(textst: String) {
        
        
        
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
        currentFilterDic = dic
        self.DoAdjustMent(inputImage: img!)
        
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
        
        if index == 0 {
            Brightness = value
        }else if index == 1 {
            Saturation = value
        }
        else if index == 2 {
            hue = value
        }
        else if index == 3 {
            sharpen = value
        }
        else if index == 4 {
            Contrast = value
        }
        
        self.DoAdjustMent(inputImage: selectedImage!)
        
    }
    
    
    
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
            self.drawView.layoutIfNeeded()
            
        }) { _ in
            
        }
    }
    
    func stickerData(sticker: String) {
        
        addSticker(test: UIImage(named: sticker)!)
        
    }
    
    
    func addText(obj:TextEdit) {
        
        
        self.hideALL()
        print("[AddText] delegate called")
        
        var fontName = ""
        var value = UserDefaults.standard.integer(forKey: "text")
        value = value + 1
        
        UserDefaults.standard.set(value, forKey: "text")
        
        let frame = CGRect(x: 0, y: 0, width: 350, height: 200)
        let sticker = TextStickerContainerView(frame: frame)
        sticker.tag = value + 700// TODO: implement in alternative way
        sticker.delegate = self
        sticker.currentFontIndex = -1
        
        
        if obj.fontName.count < 1 {
            sticker.textStickerView.font = UIFont.systemFont(ofSize: obj.fontSize)
        }else {
            sticker.textStickerView.font =  UIFont(name: obj.fontName, size: obj.fontSize)
        }
        
        
        sticker.textStickerView.text = obj.text
        
        
        sticker.textStickerView.updateTextFont()
        sticker.initilizeTextStickerData(mainTextView: sticker.textStickerView,obj: obj)
        
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
        
        
        currentTextStickerView?.scaleController.updateFrame()
    }
    
    func hideALL() {
        
        
        currentTextStickerView = nil
        for (index,view) in (stickerView.subviews.filter{($0 is StickerView) || ($0 is TextStickerContainerView)}).enumerated(){
            switch view {
            case is StickerView:
                //guard let ma = view as? StickerView else { return }
                let ma = view as! StickerView
                ma.showEditingHandlers = false
            case is TextStickerContainerView:
                let ma = view as! TextStickerContainerView
                ma.deleteController.isHidden = true
                ma.scaleController.isHidden = true
                ma.extendBarView?.isHidden = true
                ma.hideTextBorder(isHide: true)
            default:
                break
            }
            
        }
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
        self.hideALL()
        
    }
    
    
    
    
    func DoAdjustMent(inputImage: UIImage) {
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name:"CIColorControls") {
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(Brightness, forKey: kCIInputBrightnessKey)
            currentFilter.setValue(Saturation, forKey: kCIInputSaturationKey)
            currentFilter.setValue(Contrast, forKey: kCIInputContrastKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.sharpenValue(inputImage: processedImage)
                }
            }
        }
        
    }
    
    func sharpenValue (inputImage:UIImage) {
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name:"CISharpenLuminance") {
            
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(sharpen, forKey: "inputSharpness")
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.hueAdjust(inputImage: processedImage)
                }
            }
        }
    }
    
    
    
    
    
    func hueAdjust(inputImage: UIImage) {
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: "CIHueAdjust") {
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(hue, forKey: "inputAngle")
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        if self.currentFilterDic != nil {
                            self.imv.image = getFilteredImage(withInfo: self.currentFilterDic, for: processedImage)
                        }
                        else  {
                            // Memory warning
                            self.imv.image = processedImage
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func updateFrame() {
        widthForTempView.constant = holderView.frame.width
        heightForTempView.constant = holderView.frame.width
        selectedImage = UIImage(named: "lol.jpg")
        imv.image = selectedImage
        
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
            vc.drawView.isHidden = true
            
            
            if titleName.contains("Crop"){
                
                let cropViewController = Mantis.cropViewController(image:selectedImage!)
                cropViewController.delegate = self
                self.present(cropViewController, animated: true)
                
                return
            }
            
            
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
                vc.defaultHeight =  150
                vc.imageEditVc.isHidden = false
            }
            
            else if titleName.contains("Draw") {
                vc.defaultHeight = CGFloat(240)
                vc.drawView.isHidden = false
                drawView.isUserInteractionEnabled = true
            }
            
            else if titleName.contains("Adjust") {
                vc.defaultHeight = CGFloat(150)
                vc.adjustVc.isHidden = false
                
            }
            
            else if titleName.contains("Frames") {
                vc.frameVc.isHidden = false
            }
            
            else if titleName.contains("Canvas") {
                vc.defaultHeight = CGFloat(250)
                vc.canVas.isHidden = false
            }
            
            else if titleName.contains("Overlay") {
                vc.overlayVc.isHidden = false
                
                
            }
            else if titleName.contains("Shape") {
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
               
                vc.backGroundView.isHidden = false
                
            }
            else {
                
                vc.stickerVc.isHidden = false
                
            }
            vc.typeName = titleName
            
            
            if vc.defaultHeight < 300 {
                presentSheetViewController(with: vc, shouldShowSmallHeigh: true, height: vc.defaultHeight)
            }
            else {
                presentSheetViewController(with: vc, shouldShowSmallHeigh: false, height: vc.defaultHeight)
            }
            
            
           
        }
    }
    
}

extension PhotoVc: quotesDelegate {
    func sendQuoteText(text: String) {
        let obj = TextEdit()
        obj.text = text
        self.addText(obj: obj)
    }
}

private extension PhotoVc {
    func presentSheetViewController(with vc: UIViewController,shouldShowSmallHeigh:Bool,height:CGFloat) {
        
       
        if let sheet = vc.sheetPresentationController {
            
            
            let smallId = UISheetPresentationController.Detent.Identifier("small")
            if #available(iOS 16.0, *) {
                let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
                    return height
                }

                if shouldShowSmallHeigh {
                    sheet.detents = [smallDetent]
                    sheet.largestUndimmedDetentIdentifier = smallId
                }
                else {
                    sheet.detents = [.medium(),smallDetent, .large()]
                    sheet.largestUndimmedDetentIdentifier = .large
                }
                
            } else {
                // Fallback on earlier versions
            }
            
           
            sheet.selectedDetentIdentifier = .none
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
