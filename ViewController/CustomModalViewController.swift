//
//  CustomModalViewController.swift
//  HalfScreenPresentation
//
//  Created by Hafiz on 06/06/2021.
//

import UIKit


@objc protocol allDelegate: AnyObject {
    func sendCanvasData(width:Int,height:Int)
    func stickerData(sticker: String)
    func sendFrame(frames:String)
    func sendOverLay(image:UIImage?)
    func sendAdjust(value: Float, index: Int)
    func sendFilter(dic: Dictionary<String, Any>?)
    @objc optional func sendOverLayValue(value:CGFloat)
    func sendShapeValue(sticker: String)
}

class CustomModalViewController: UIViewController, sendSticker, canvasSend, sendFrames, imageIndexDelegate, sendValueForAdjust, filterIndexDelegate, sendImageDelegate, sendShape {
    
    
    func sendShape(sticker: String) {
        
        delegateForEditedView?.sendShapeValue(sticker: sticker)
    }
    
    func changeValueForOverlay(value: CGFloat) {
        delegateForEditedView?.sendOverLayValue?(value: value)
    }
    
    
    
    func sendImage() {
         
    }
    
    func changeImageOpacity(value: Float) {
         
    }
    
    func chnageValue(value: Float, index: Int) {
        
    }
    
    

    func filterNameWithIndex(dic: Dictionary<String, Any>?) {
    
        delegateForEditedView?.sendFilter(dic: dic)
        
    }
    func sendAdjustValue(value: Float, index: Int) {
        delegateForEditedView?.sendAdjust(value: value, index: index)
    }
    
    
    
    func imageNameWithIndex(tag: String, image: UIImage?) {
    
        delegateForEditedView?.sendOverLay(image: image)
    }
    
    func sendFramesIndex(frames: String) {
        delegateForEditedView?.sendFrame(frames: frames)
    }
    
    
    weak var delegateForEditedView: allDelegate?
    
    func sendValue(width: Int, height: Int) {
        delegateForEditedView?.sendCanvasData(width: width, height: height)
    }

    func sendSticker(sticker: String) {
        delegateForEditedView?.stickerData(sticker: sticker)
        
    }

    let stickerVc = Bundle.main.loadNibNamed("StickerVc", owner: nil, options: nil)![0] as! StickerVc
    let overlayVc = Bundle.main.loadNibNamed("OverLayVc", owner: nil, options: nil)![0] as! OverLayVc
    let canVas = Bundle.main.loadNibNamed("CanVas", owner: nil, options: nil)![0] as! CanVas
    let shapeVc = Bundle.main.loadNibNamed("ShapeVc", owner: nil, options: nil)![0] as! ShapeVc
    let frameVc = Bundle.main.loadNibNamed("FrameVc", owner: nil, options: nil)![0] as! FrameVc
    let adjustVc = Bundle.main.loadNibNamed("Adjust", owner: nil, options: nil)![0] as! Adjust
    let filterVc = Bundle.main.loadNibNamed("FilterVc", owner: nil, options: nil)![0] as! FilterVc
    let imageEditVc = Bundle.main.loadNibNamed("ImageEditView", owner: nil, options: nil)![0] as! ImageEditView
    let backGroundView = Bundle.main.loadNibNamed("BackGround", owner: nil, options: nil)![0] as! BackGround



    var typeName: String = ""
    var gesturreView:UIView!
    var smallView:UIView!
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 27.0/255.0, green: 27.0/255.0, blue: 27.0/255.0, alpha: 1.0) 
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        
        var stackView:UIStackView!
        
        if typeName.contains("Background") {
            stackView = UIStackView(arrangedSubviews: [spacer, backGroundView, spacer])
            stackView.axis = .vertical
        }
        else if typeName.contains("Canvas") {
            stackView = UIStackView(arrangedSubviews: [spacer, canVas, spacer])
            canVas.delegateForSticker = self
            stackView.axis = .vertical
        }
        else if typeName.contains("Image") {
            stackView = UIStackView(arrangedSubviews: [spacer, imageEditVc, spacer])
            imageEditVc.delegateForImage = self
            stackView.axis = .vertical
        }
        else if typeName.contains("Filter") {
            stackView = UIStackView(arrangedSubviews: [spacer, filterVc, spacer])
            filterVc.delegateForFilter = self
            stackView.axis = .vertical
        }
        else if typeName.contains("Adjust") {
            stackView = UIStackView(arrangedSubviews: [spacer, adjustVc, spacer])
            adjustVc.delegate = self
            stackView.axis = .vertical
        }
        
        else if typeName.contains("Frames") {
            stackView = UIStackView(arrangedSubviews: [spacer, frameVc, spacer])
            frameVc.delegateForFramesr = self
            stackView.axis = .vertical
            
        }
        else if typeName.contains("Graphics") {
            stackView = UIStackView(arrangedSubviews: [spacer, stickerVc, spacer])
            stickerVc.delegateForSticker = self
            stackView.axis = .vertical
        }
        else if typeName.contains("Shape") {
            stackView = UIStackView(arrangedSubviews: [spacer, shapeVc, spacer])
            shapeVc.delegateForShape = self
            stackView.axis = .vertical
        }
        else {
            stackView = UIStackView(arrangedSubviews: [spacer, overlayVc, spacer])
            overlayVc.delegateForOverlay = self
            stackView.axis = .vertical
        }
       
        //stackView.distribution = .fill
        //stackView.alignment = .center
        
        return stackView
    }()
    
    let maxDimmedAlpha: CGFloat = 0.1
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    var defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    var maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
        gesturreView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20.0))
        smallView = UIView(frame: CGRect(x: (gesturreView.frame.width - 100)/2.0, y: 5  , width: 100, height: 7.0))
        smallView.layer.cornerRadius =  5.0
        smallView.backgroundColor = titleColor
        gesturreView.addSubview(smallView)
        containerView.addSubview(gesturreView)
        setupConstraints()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    

    
    func setupConstraints() {
        // Add subviews
        
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        stickerVc.frame = CGRect(x: 0,y: gesturreView.frame.height,width: self.view.frame.size.width, height: maximumContainerHeight)
        
        overlayVc.frame = CGRect(x: 0,y: gesturreView.frame.height,width: self.view.frame.size.width, height: CGFloat(overLayHeight))
        
        
        stickerVc.delegateForSticker = self
        
        
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set container static constraint (trailing & leading)
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
           
        ])
        
        //containerView.addSubview(stickerVc)
        //containerView.addSubview(overlayVc)
        
      //  stickerVc.isHidden = true
        
        
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}
