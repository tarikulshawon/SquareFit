//
//  HomeVc.swift
//  SquareFit
//
//  Created by Macbook pro 2020 M1 on 13/1/23.
//

import UIKit
import PhotosUI
import AVKit

class HomeVc: UIViewController, PHPickerViewControllerDelegate {
    
    var isFromPhoto = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func gotoVideos(_ sender: Any) {
        
        isFromPhoto = false
        let newFilter = PHPickerFilter.any(of: [.videos])
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.filter = newFilter
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        configuration.selection = .ordered
        configuration.selectionLimit = 1
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if isFromPhoto {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoVc") as! PhotoVc
            vc.modalPresentationStyle = .fullScreen
            
            for result in results {
                  result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                     if let image = object as? UIImage {
                        DispatchQueue.main.async {
                           // Use UIImage
                           print("Selected image: \(image)")
                            vc.selectedImage = image
                        }
                     }
                  })
               }
            
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoVc") as! VideoVc
            vc.modalPresentationStyle = .fullScreen
            
            // TODO: same code for picking video from phone. 
            
            self.present(vc, animated: true, completion: nil)
            
        }
    }
        
        
        @IBAction func gotoPhotos(_ sender: Any) {
            isFromPhoto = true
            let newFilter = PHPickerFilter.any(of: [.images])
            let photoLibrary = PHPhotoLibrary.shared()
            var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
            configuration.filter = newFilter
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            configuration.selection = .ordered
            configuration.selectionLimit = 1
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
