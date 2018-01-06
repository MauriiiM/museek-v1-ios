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

/**
 @TODO: look into https://developer.apple.com/documentation/photos
 */
class MediaLibraryVC: UIViewController {
    fileprivate var moviePicker: UIImagePickerController = UIImagePickerController()
    fileprivate var selectedMovie: URL?
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        presentMediaGallery()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uploadVC = segue.destination as! UploadVC
        if let movie = selectedMovie {
            uploadVC.url.movie = movie
            print(movie.absoluteString)
        }
        moviePicker.dismiss(animated: true, completion: nil)
    }
    
    /**
     is called when a video is selected
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let selectedURL = info["UIImagePickerControllerMediaURL"] as? URL {
            selectedMovie = selectedURL
            performSegue(withIdentifier: "toUploadVC", sender: self)
        }
    }
    
    /**
     called when user hits cancel in image picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        moviePicker.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "turnToPreviousPage"), object: nil)
    }
    
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

// MARK: - UIImagePickerControllerDelegate
extension MediaLibraryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     sets up UIImagePicker and presents the library view
     */
    private func startMediaBrowser(usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) { //source is available
            
            moviePicker.sourceType = .savedPhotosAlbum
            moviePicker.mediaTypes = [kUTTypeMovie as String]
            moviePicker.modalPresentationStyle = .popover
            moviePicker.allowsEditing = false
            moviePicker.delegate = delegate
            present(moviePicker, animated: true, completion: nil)
        }
    }
}
