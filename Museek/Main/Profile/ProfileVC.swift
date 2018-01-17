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
        Permissions.checkLibraryAuthorization { status in
            if status == .authorized { self.startMediaBrowser(usingDelegate: self) }
            else { print("Permission to access library denied.") }
        }
    }
}
