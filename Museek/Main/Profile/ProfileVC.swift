//
//  ProfileVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/4/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Photos

class ProfileVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    fileprivate var imagePicker: UIImagePickerController = UIImagePickerController()
    fileprivate var user: User?
    fileprivate var headerCell: ProfileHeaderCollectionReusableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource  = self
        fetchUser()
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
        headerView.profileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        headerView.profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        if let user = user { headerView.user = user }
        headerCell = headerView
        return headerView
    }
    
    /**
     gets current user info and updates header view
     */
    fileprivate func fetchUser(){
        Api.User.observeCurrentUser(){ user in
            self.user = user
            self.collectionView.reloadData()
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            headerCell?.profileImage.image = image
            upload(image: image){ imageURL in
                self.upload(imageURL: imageURL)
                self.dismiss(animated: true)
            }
        }
    }
    
    /**
     upload given URL to given online storage
     */
    fileprivate func upload(image: UIImage, onSuccess: @escaping (_ imageURL: String) -> Void){
        let thumbnailData = UIImageJPEGRepresentation(image, 0.75)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        Storage.storage().reference().child("profileImages").child(UUID().uuidString).putData(thumbnailData!, metadata: metaData) {(metadata, error) in
            if error != nil { return }
            onSuccess(metadata!.downloadURL()!.absoluteString)
        }
    }
    
    fileprivate func upload(imageURL: String){
        let newPostRef = Api.User.REF_CURRENT_USER!
        newPostRef.child("profileImageURL").setValue(imageURL)
    }
}
