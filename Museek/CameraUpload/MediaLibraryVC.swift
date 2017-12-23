//
//  MediaGalleryVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/19/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

// MARK: - UIImagePickerControllerDelegate
extension MediaLibraryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     sets up UIImagePicker and presents the library view
     */
    private func startMediaBrowser(usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) { //source is available
            
            moviePicker.sourceType = .photoLibrary
            moviePicker.mediaTypes = [kUTTypeMovie as String]
            moviePicker.modalPresentationStyle = .currentContext
            moviePicker.allowsEditing = false
            moviePicker.delegate = delegate
            present(moviePicker, animated: true, completion: nil)
        }
    }
}


/**
 @TODO: look into https://developer.apple.com/documentation/photos
 */
class MediaLibraryVC: UIViewController {
    
    var moviePicker: UIImagePickerController = UIImagePickerController()
    var selectedMovie: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLibraryAuthorization { status in
            if status == .authorized { self.startMediaBrowser(usingDelegate: self) }
            else { print("Permission to access library denied.") }
        }
        print("MediaLibraryVC viewDidLoad")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uploadVC = segue.destination as! UploadVC
        if let movie = selectedMovie {
            uploadVC.movieURL = movie
        }
        moviePicker.dismiss(animated: true, completion: nil)
    }
    
    /**
     is called when a video is selected
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //        if let selectedMovie = info.first
        performSegue(withIdentifier: "MediaGalleryToUpload", sender: self)
    }
    
    /**
     called when user hits cancel in image picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        moviePicker.dismiss(animated: true, completion: nil)
    }
    
    /**
     checks if user has previously authorized app to use camera
     */
    private func checkLibraryAuthorization(_ completionHandler: @escaping ((_ status: PHAuthorizationStatus) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(.authorized)
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
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
