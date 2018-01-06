//
//  ProfileVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/4/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos

class ProfileVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    fileprivate var imagePicker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource  = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction fileprivate func logoutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let sb = UIStoryboard(name: "Opening", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    @objc fileprivate func imageTapped(){
        presentMediaGallery()
    }
}







extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
//        headerView.updateView()
        headerView.profileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        headerView.profileImage.addGestureRecognizer(tapGestureRecognizer)
        headerView.updateView()
        return headerView
    }
}








extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func startMediaBrowser(usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) { //source is available
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .popover
//            imagePicker.allowsEditing = false
            imagePicker.delegate = delegate
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //@TODO bottom 2 functions are used in mediaGallery, so clean to use once
    func presentMediaGallery(){
        self.checkLibraryAuthorization { status in
            if status == .authorized { self.startMediaBrowser(usingDelegate: self) }
            else { print("Permission to access library denied.") }
        }
    }
    
    /**
     checks if user has previously authorized app to use camera
     */
    fileprivate func checkLibraryAuthorization(_ completionHandler: @escaping ((_ status: PHAuthorizationStatus) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(.authorized)
        case .notDetermined:
            // The user has not yet been presented with the option to grant camera access so request access.
            PHPhotoLibrary.requestAuthorization({ permission in
                completionHandler(permission)
            })
        case .denied:
            // The user has previously denied access.
            completionHandler(.denied)
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(.restricted)
        }
    }
}
