//
//  VideoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 20/1/23.
//

import UIKit

class VideoVc: UIViewController, UIGestureRecognizerDelegate, allDelegate {
    
    func sendCanvasData(width: Int, height: Int) {
         
        let result = CGFloat(height*Int(previewContainer.frame.width))/CGFloat(width)
        UIView.animate(withDuration: 0.4, animations: {
            
            if result > self.previewContainer.frame.height {
                let result1 = CGFloat(width*Int(self.previewContainer.frame.height))/CGFloat(height)
                self.widthForV.constant = result1
                self.heightForV.constant =  self.previewContainer.frame.height
                
            } else {
                
                self.widthForV.constant = self.previewContainer.frame.width
                self.heightForV.constant =  result
            }
            
            self.view.layoutIfNeeded()
             
        }) { _ in
            
        }
        
    }
    
    
    
    func stickerData(sticker: String) {
         
    }
    
    func sendFrame(frames: String) {
         
    }
    
    func sendOverLay(image: UIImage?) {
         
    }
    
    func sendAdjust(value: Float, index: Int) {
         
    }
    
    
    @IBOutlet weak var btnCollectionView: UICollectionView!
    @IBOutlet weak var widthForV: NSLayoutConstraint!
    @IBOutlet weak var heightForV: NSLayoutConstraint!
    
    var panRecogniser:UIPanGestureRecognizer! = nil
    var pinchRecogniser:UIPinchGestureRecognizer! = nil
    var tapRecogniser: UITapGestureRecognizer! =  nil
    
    @IBOutlet weak var blurVideoPreviewContainer: PlaybackView!
    @IBOutlet weak var videoPreviewContainer: PlaybackView!
    
    
    @IBOutlet weak var squareContainerView: UIView!
    @IBOutlet weak var previewContainer: UIView!
    
    
    let  flipScaleY = 1.0
    let flipScaleX = 1.0
    var scale = 1.0
 
    var videoDuration:CGFloat = 1.0
    var playerItem:AVPlayerItem! = nil
    var player:AVPlayer! = nil
    var videoAsset:AVAsset!  = nil
    var naturalVideoSize:CGSize! = nil
    var videoThumb:UIImage! = nil
    let ratioWidth:CGFloat = 1.0
    let ratioHeight:CGFloat = 1.0
    let isMute = false
    let currentProgress:CGFloat = 0.0
    let selectedColor = UIColor.red
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0
    @IBOutlet weak var backgroundImgView: UIImageView!
    var btnArray: NSArray! = nil

    
    
    let isBackgroundImage = false
    let isBlur = false
    let isColor = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalGesture()
        self.initVideoAsset()
        
        let path = Bundle.main.path(forResource: "videobtn", ofType: "plist")
        btnArray = NSArray(contentsOfFile: path!)
        initCollectionView()
        self.perform(#selector(self.updateFrame), with: self, afterDelay:0.1)
        
        // Do any additional setup after loading the view.
    }
    
    func initCollectionView() {
        let emptyAutomationsCell = RatioCell.nib
        btnCollectionView?.register(emptyAutomationsCell, forCellWithReuseIdentifier: RatioCell.reusableID)
        btnCollectionView.delegate = self
        btnCollectionView.dataSource = self
    }
    
    
    @objc func updateFrame() {
        
        widthForV.constant = previewContainer.frame.width
        heightForV.constant = previewContainer.frame.width
        
        
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
    
    
    func initVideoAsset() {
        
        
        guard let path = Bundle.main.path(forResource: "mama", ofType:"mov") else {
            debugPrint("video.m4v not found")
            return
        }
        
        
        if #available(iOS 16.0, *) {
            videoAsset =  AVURLAsset(url:  URL(filePath: path))
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 16.0, *) {
            videoThumb = getThumbnailImage(forUrl: URL(filePath: path))
        } else {
            // Fallback on earlier versions
        }
        ExportManager.sharedManger.originalVideoAsset = videoAsset
        ExportManager.sharedManger.range =  CMTimeRangeMake(start: .zero, duration: videoAsset.duration)
        let videoTrack = videoAsset.tracks(withMediaType: .video).first
        var videoSize: CGSize? = nil
        if let preferredTransform = videoTrack?.preferredTransform {
            videoSize = videoTrack?.naturalSize.applying(preferredTransform)
        }
        naturalVideoSize = CGSize(width: CGFloat(abs(Float(videoSize?.width ?? 0.0))), height: CGFloat(abs(Float(videoSize?.height ?? 0.0))))
        
        
        backgroundImgView.image = videoThumb
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.loadPlayerItem(ExportManager.sharedManger.createComposition(withMuteStatus: false), self.videoPreviewContainer.bounds)
            
        })
        //  self.exportVideo()
        
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    
    func initalGesture() {
        panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pinchRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        squareContainerView.addGestureRecognizer(panRecogniser)
        squareContainerView.addGestureRecognizer(pinchRecogniser)
        squareContainerView.addGestureRecognizer(tapRecogniser)
        panRecogniser.delegate = self
        pinchRecogniser.delegate = self
        tapRecogniser.delegate = self
    }
    
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc private func didPan(_ recogniser: UIPanGestureRecognizer) {
        
        if recogniser.state == .began || recogniser.state == .changed {
            let panTranslation = recogniser.translation(in: videoPreviewContainer.superview)
            let translatedCenter = CGPoint(x: videoPreviewContainer.center.x + panTranslation.x, y: videoPreviewContainer.center.y + panTranslation.y)
            videoPreviewContainer.center = translatedCenter
            recogniser.setTranslation(.zero, in: videoPreviewContainer)
        }
    }
    
    
    @objc private func didPinch(_ recogniser: UIPinchGestureRecognizer) {
        
        if recogniser.state == .began {
            recogniser.scale = scale
        }
        
        if recogniser.state == .ended {
            scale = recogniser.scale
        }
        
        videoPreviewContainer.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        videoPreviewContainer.transform = CGAffineTransform(scaleX: recogniser.scale * CGFloat(flipScaleX), y: recogniser.scale * CGFloat(flipScaleY))
        
    }
    
    @objc private func didTap(_ recogniser: UITapGestureRecognizer) {
        
        
    }
    
    func loadPlayerItem(_ composition: AVMutableComposition?, _ frame: CGRect) {
        
        if let duration = composition?.duration {
            videoDuration = CMTimeGetSeconds(duration)
        }
        if let composition {
            playerItem = AVPlayerItem(asset: composition)
        }
        
        if (player == nil) {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player.replaceCurrentItem(with: playerItem)
        }
        
        videoPreviewContainer.player = player
        //videoPreviewContainer.backgroundColor = UIColor.red
        player.play()
    }
    
    
}

extension VideoVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
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
            
            if titleName.contains("Adjust") {
                vc.defaultHeight = CGFloat(adjustHeight)
                vc.maximumContainerHeight = CGFloat(adjustHeight)
                vc.adjustVc.isHidden = false
            }
            
            if titleName.contains("Frames") {
                vc.defaultHeight = CGFloat(framesVcHeight)
                vc.frameVc.isHidden = false
            }
            
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
            else if titleName.contains("Shape") {
                vc.defaultHeight = CGFloat(shapeVcHeight)
                vc.maximumContainerHeight = CGFloat(shapeVcHeight)
                vc.shapeVc.isHidden = false
                
            }
            else if titleName.contains("Filter") {
                vc.defaultHeight = CGFloat(filterHeight)
                vc.filterVc.isHidden = false
                
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

private extension VideoVc {
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
