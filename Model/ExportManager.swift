//
//  Store.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 19/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ExportManager: NSObject {
    
    static let sharedManger = ExportManager()
    var range:CMTimeRange! = nil
    var  originalVideoAsset:AVAsset! = nil
    let backGroundImage:UIImage! = nil
    var assetExport:AVAssetExportSession! = nil
    var exportPath = ""
    var exportProgressBarTimer:Timer!
    var currentProgress = 0.0
    var selectedFilterName = ""
    var selectedIndexForVideBlur = 0
    var video_sliderValue = 0
    var isMUte  = false
    var videoPreviewContainer:PlaybackView! = nil
    var ratioWidth = 1.0
    var ratioHeight = 1.0
    var scale = 1.0
    var flipScaleX = 1.0
    var flipScaleY  = 1.0
    var isBackgroundImage = false
    var isBlur = false
    var isColor = false
    var backGroundColor = UIColor.red
    
    func createComposition(withMuteStatus isMute: Bool) -> AVMutableComposition? {
        let mixComposition = AVMutableComposition()
        let range = CMTimeRangeMake(start: self.range.start, duration: self.range.duration)
        
        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        if let firstObject = originalVideoAsset.tracks(withMediaType: .video).first {
            try? compositionVideoTrack?.insertTimeRange(range, of: firstObject, at: .zero)
        }
        
        if !isMute {
            let compositionAudioofVideoTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let firstObject = originalVideoAsset.tracks(withMediaType: .audio).first {
                try? compositionAudioofVideoTrack?.insertTimeRange(range, of: firstObject, at: .zero)
            }
        }
        return mixComposition
    }
    
    func getBackgroundVideoAsset(_ _asset: AVAsset?, completion completionBlock: @escaping (_ bgAsset: AVAsset?) -> Void) {
        let path = Bundle.main.path(forResource: "square_blank", ofType: "mov")
        let trackUrl = URL(fileURLWithPath: path ?? "")
        let asset = AVAsset(url: trackUrl)
        let track = asset.tracks(withMediaType: .video).first
        let range = CMTimeRangeMake(start: self.range.start, duration: self.range.duration)
        
        let mixComposition = AVMutableComposition()
        
        let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        if let firstObject = asset.tracks(withMediaType: .video).first {
            try? compositionVideoTrack?.insertTimeRange(range, of: firstObject, at: .zero)
        }
        
        let videoTransform = track?.preferredTransform
        var naturalSize = track?.naturalSize.applying(videoTransform!)
        naturalSize = CGSize(width: CGFloat(abs(Float(naturalSize!.width))), height: CGFloat(abs(Float(naturalSize!.height))))
        let composition = AVMutableVideoComposition(propertiesOf: asset)
        self.addOverlayImage(backGroundImage, toVideo: composition, in: naturalSize!)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero, duration: range.duration)
        composition.instructions = [instruction]
        
        assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        assetExport.videoComposition = composition
        
        exportPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("exported-\(arc4random() % 100000).mov").path
        
        
        let exportUrl = URL(fileURLWithPath: exportPath)
        assetExport.outputURL = exportUrl
        assetExport.shouldOptimizeForNetworkUse = true
        
        assetExport.exportAsynchronously(completionHandler: {
            
            DispatchQueue.main.async(execute: { [self] in
                
                switch assetExport.status {
                case AVAssetExportSession.Status.failed:
                    exportProgressBarTimer.invalidate()
                    exportProgressBarTimer = nil
                case AVAssetExportSession.Status.exporting:
                    break
                    
                case AVAssetExportSession.Status.completed:
                    currentProgress = 0.5
                    exportProgressBarTimer.invalidate()
                    exportProgressBarTimer = nil
                    print("Background Video Exported Successfully.")
                    var finalAsset: AVAsset? = nil
                    if let outputURL = assetExport.outputURL {
                        finalAsset = AVAsset(url: outputURL)
                    }
                    completionBlock(finalAsset)
                    break
                    
                default:
                    break
                }
                
            })
        })
        
        DispatchQueue.main.async(execute: {
            self.exportProgressBarTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        })
    }
    
    @objc func update() {
        currentProgress = Double(assetExport.progress/2.0)
    }
    @objc func update1() {
        var progress = 0
        if currentProgress == 0.5 {
            progress = Int(0.5 + assetExport.progress / 2.0)
        } else {
            progress = Int(assetExport.progress)
        }
        
    }
    
    func addOverlayImage(_ overlayImage: UIImage?, toVideo composition: AVMutableVideoComposition?, in size: CGSize) {
        // 1 - set up the overlay
        let overlayLayer = CALayer()
        
        overlayLayer.contents = overlayImage?.cgImage
        overlayLayer.contentsGravity = .resizeAspectFill
        
        overlayLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        overlayLayer.masksToBounds = true
        
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        composition?.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: parentLayer)
        
    }
    
    
    func export(withPreExportedAsset blurAsset: AVAsset?, andBackgroundAsset bgAsset: AVAsset?) {
        
        let composition = AVMutableComposition()
        let exportVideoComposition = AVMutableVideoComposition()
        
        let assetTrack = originalVideoAsset.tracks(withMediaType: .video).first
        let compositionTrackVideo = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? compositionTrackVideo?.insertTimeRange(CMTimeRangeMake(start: range.start, duration: range.duration), of: assetTrack!, at: .zero)
        
        if !isMUte {
            let audioAssetTrack = originalVideoAsset.tracks(withMediaType: .audio).first
            if let audioAssetTrack {
                let compositionTrackAudio = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                
                try? compositionTrackAudio?.insertTimeRange(CMTimeRangeMake(start: range.start, duration: range.duration), of: audioAssetTrack, at: .zero)
            }
        }
        
        let videoTransform = assetTrack?.preferredTransform
        var naturalSize = assetTrack?.naturalSize.applying(videoTransform!)
        naturalSize = CGSize(width: CGFloat(abs(Float(naturalSize!.width))), height: CGFloat(abs(Float(naturalSize!.height))))
        let tempRect = videoPreviewContainer.frame
        
        let w = ratioWidth
        let h = ratioHeight
        
        if w == h {
            let maxSize = fmaxf(Float(naturalSize!.width), Float(naturalSize!.height))
            exportVideoComposition.renderSize = CGSize(width: CGFloat(maxSize), height: CGFloat(maxSize))
        }
        
        else if w > h {
            let r: CGFloat = (w / h)
            let n: CGFloat = (naturalSize!.width / (naturalSize?.height ?? 0))
            if naturalSize!.width > naturalSize!.height {
                if r > n {
                    exportVideoComposition.renderSize = CGSize(width: naturalSize!.height * r, height: naturalSize!.height)
                } else {
                    exportVideoComposition.renderSize = CGSize(width: naturalSize!.width, height: naturalSize!.width / r)
                }
            } else {
                exportVideoComposition.renderSize = CGSize(width: naturalSize!.height * r, height: naturalSize!.height)
            }
        }
        else {
            let r = w/h
            let n = naturalSize!.width / naturalSize!.height
            if(naturalSize!.width > naturalSize!.height) {
                exportVideoComposition.renderSize = CGSizeMake(naturalSize!.width, naturalSize!.width / r)
            }
            else {
                if (r>n) {
                    exportVideoComposition.renderSize = CGSizeMake(naturalSize!.height * r, naturalSize!.height)
                }
                else {
                    exportVideoComposition.renderSize = CGSizeMake(naturalSize!.width, naturalSize!.width / r)
                }
            }
        }
        
        let layerRect = videoPreviewContainer.playerLayer.videoRect
        var x = ((tempRect.origin.x + layerRect.origin.x * scale) / videoPreviewContainer.bounds.size.width) * exportVideoComposition.renderSize.width
        var y = ((tempRect.origin.y + layerRect.origin.y * scale) / videoPreviewContainer.bounds.size.height) * exportVideoComposition.renderSize.height
        
        let scaleTransform = videoTransform!.concatenating(CGAffineTransform(scaleX: scale * flipScaleX, y: scale * flipScaleY))
        var newSize = naturalSize!.applying(CGAffineTransform(scaleX: scale * flipScaleX, y: scale * flipScaleY))
        newSize = CGSize(width: CGFloat(abs(Float(newSize.width))), height: CGFloat(abs(Float(newSize.height))))
        
        
        if flipScaleX < 0 {
            x += newSize.width
        }
        if flipScaleY < 0 {
            y += newSize.height
        }
        
        let finalTransform = scaleTransform.concatenating(CGAffineTransform(translationX: x, y: y))
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrackVideo!)
        layerInstruction.setTransform(finalTransform, at: .zero)
        layerInstruction.setOpacity(0.0, at: range.duration)
        
        var instructions: [AVMutableVideoCompositionLayerInstruction] = []
        instructions.append(layerInstruction)
        
        if isBackgroundImage {
            let assetTrack_bg = bgAsset!.tracks(withMediaType: .video).first
            let compositionTrackVideo_bg = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let assetTrack_bg {
                try? compositionTrackVideo_bg?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: range.duration), of: assetTrack_bg, at: .zero)
            }
            let layerInstruction_bg = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrackVideo_bg!)
            let r1 = exportVideoComposition.renderSize.width / (assetTrack_bg?.naturalSize.width)!
            let r2 = exportVideoComposition.renderSize.height / assetTrack_bg!.naturalSize.height
            
            let ratio = CGFloat(max(r1, r2))
            let Scale = CGAffineTransform(scaleX: ratio, y: ratio)
            let calculatedSize = assetTrack_bg?.naturalSize.applying(Scale)
            let translation = CGAffineTransform(translationX: -(calculatedSize!.width - exportVideoComposition.renderSize.width) / 2, y: -(calculatedSize!.height - exportVideoComposition.renderSize.height) / 2)
            layerInstruction_bg.setTransform(Scale.concatenating(translation), at: .zero)
            instructions.append(layerInstruction_bg)
        }
        
        if isBlur {
            let assetTrack_blur = blurAsset!.tracks(withMediaType: .video).first
            let compositionTrackVideo_blur = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let assetTrack_blur {
                try? compositionTrackVideo_blur?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: range.duration), of: assetTrack_blur, at: .zero)
            }
            let layerInstruction_blur = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrackVideo_blur!)
            let blur_videoTransform = assetTrack_blur!.preferredTransform
            var blur_video_naturalSize = assetTrack_blur!.naturalSize.applying(blur_videoTransform)
            blur_video_naturalSize = CGSize(width: CGFloat(abs(Float(blur_video_naturalSize.width))), height: CGFloat(abs(Float(blur_video_naturalSize.height))))
            
            let exportSize = exportVideoComposition.renderSize
            let maxSize = fmaxf(Float(exportSize.width), Float(exportSize.height))
            let div = fminf(Float(blur_video_naturalSize.width), Float(blur_video_naturalSize.height))
            let ratio = maxSize / div
            let Scale = CGAffineTransform(scaleX: CGFloat(ratio), y: CGFloat(ratio))
            let scaleTransform = blur_videoTransform.concatenating(Scale)
            let calculatedSize = blur_video_naturalSize.applying(Scale)
            let translation = CGAffineTransform(translationX: -(calculatedSize.width - exportVideoComposition.renderSize.width) / 2, y: -(calculatedSize.height - exportVideoComposition.renderSize.height) / 2)
            let finalTransform = scaleTransform.concatenating(translation)
            layerInstruction_blur.setTransform(finalTransform, at: .zero)
            layerInstruction_blur.setOpacity(0.0, at: range.duration)
            instructions.append(layerInstruction)
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: range.duration)
        mainInstruction.layerInstructions = instructions
        exportVideoComposition.instructions = [mainInstruction]
        exportVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        
        if (isColor) {
            mainInstruction.backgroundColor = backGroundColor.cgColor
        }
        
        assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        assetExport.videoComposition = exportVideoComposition
        assetExport.outputFileType = .mp4
        exportPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("exported-\(arc4random() % 100000).mp4").path
        let exportUrl = URL(fileURLWithPath: exportPath)
        assetExport.outputURL = exportUrl
        assetExport.shouldOptimizeForNetworkUse = true
        
        DispatchQueue.main.async(execute: { [self] in
          //  self.exportProgressBarTimer.invalidate()
            exportProgressBarTimer = nil
        //    self.exportProgressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
            
        })
        
        assetExport.exportAsynchronously(completionHandler: {
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isIdleTimerDisabled = false
                
                switch self.assetExport.status {
                case AVAssetExportSession.Status.failed:
                    self.exportProgressBarTimer.invalidate()
                    self.exportProgressBarTimer = nil
                case AVAssetExportSession.Status.exporting:
                    break
                    
                case AVAssetExportSession.Status.completed:
                    self.currentProgress = 0.5
                   // self.exportProgressBarTimer.invalidate()
                    self.exportProgressBarTimer = nil
                    print("Background Video Exported Successfully.")
                    var finalAsset: AVAsset? = nil
                    if let outputURL = self.assetExport.outputURL {
                        finalAsset = AVAsset(url: outputURL)
                        
                        
                    }
                    
                    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

                    if var topController = keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }

                        
                        let vc = topController.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                        vc.asset = finalAsset
                        topController.present(vc, animated: true, completion: nil)
                     
                    }
                    
                    break
                    
                default:
                    break
                }
                
                
            })
            
        })
        
    }
    
    
    func getBlurVideoAsset(_ inputAsset: AVAsset?, completion completionBlock: @escaping (_ outputAsset: AVAsset?) -> Void) {
        
        let chooseFilter = selectedFilterName
        let assetVideoTrack = originalVideoAsset.tracks(withMediaType: .video).first
        let cmp = createComposition(withMuteStatus: true)
        if let cmp {
            assetExport = AVAssetExportSession(asset: cmp, presetName: AVAssetExportPresetHighestQuality)
        }
        let filter = CIFilter(name: chooseFilter)
        
        let  composition = AVVideoComposition(
            asset: cmp!,
            applyingCIFiltersWithHandler: { [self] request in
                if selectedIndexForVideBlur == 0 {
                    request.finish(with: request.sourceImage, context: nil)
                    return
                }
                
            })
        
        assetExport.videoComposition = composition
        exportPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("exported-\(arc4random() % 100000).mov").path
        
        let exportUrl = URL(fileURLWithPath: exportPath)
        assetExport.outputURL = exportUrl
        assetExport.shouldOptimizeForNetworkUse = true
        
        DispatchQueue.main.async(execute: {
            self.exportProgressBarTimer.invalidate()
            self.exportProgressBarTimer = nil
            self.exportProgressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        })
        
        assetExport.exportAsynchronously(completionHandler: {
            
            DispatchQueue.main.async(execute: { [self] in
                
                switch assetExport.status {
                case AVAssetExportSession.Status.failed:
                    exportProgressBarTimer.invalidate()
                    exportProgressBarTimer = nil
                case AVAssetExportSession.Status.exporting:
                    break
                    
                case AVAssetExportSession.Status.completed:
                    currentProgress = 0.5
                    exportProgressBarTimer.invalidate()
                    exportProgressBarTimer = nil
                    print("Background Video Exported Successfully.")
                    var finalAsset: AVAsset? = nil
                    if let outputURL = assetExport.outputURL {
                        finalAsset = AVAsset(url: outputURL)
                    }
                    completionBlock(finalAsset)
                    break
                    
                default:
                    break
                }
                
            })
        })
        
        
    }
    
}
