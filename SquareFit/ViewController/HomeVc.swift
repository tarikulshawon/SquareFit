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
        
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if isFromPhoto {
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                
                                
                            }
                        }
                    }
                }
            } else {
            }
        }
    }
    
    
    @IBAction func gotoPhotos(_ sender: Any) {
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
