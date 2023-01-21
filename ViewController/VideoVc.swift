//
//  VideoVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 20/1/23.
//

import UIKit

class VideoVc: UIViewController, UIGestureRecognizerDelegate {
    
    
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
    
    
    let isBackgroundImage = false
    let isBlur = false
    let isColor = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalGesture()
        
        // Do any additional setup after loading the view.
    }
    
    func initVideoAsset() {
        
        
        guard let path = Bundle.main.path(forResource: "mama", ofType:"mp4") else {
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
