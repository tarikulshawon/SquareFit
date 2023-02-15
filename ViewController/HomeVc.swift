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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var isFromPhoto = true
    var pArray:NSArray! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let path = Bundle.main.path(forResource: "home", ofType: "plist")
        pArray = NSArray(contentsOfFile: path!)
        collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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




extension HomeVc:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (480*110)/360, height: 110)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return  pArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath) as? ShowIcon else {
            return ShowIcon()
        }
        
       
        cell.imv
            .image = UIImage(named: pArray[indexPath.row] as! String)
        cell.imv.backgroundColor = UIColor.clear
        
        cell.widthF.constant =  (480*110)/360
        cell.heightF.constant = 110
       
        
        return cell
    }
}
