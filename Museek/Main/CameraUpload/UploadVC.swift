//
//  UploadVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/15/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import CoreLocation

class UploadVC: UIViewController, ContainerMaster {
    fileprivate var _videoViewLoaded: Bool?{
        didSet{
            giveContainerGestureRecognizer()
        }
    }
    var videoViewLoaded: Bool?{
        get{ return _videoViewLoaded }
        set{ _videoViewLoaded = newValue }
    }
    
    fileprivate var thumbnail: UIImage?
    fileprivate var _url: (movie: URL?, highlightClip: URL?)?{
        didSet{
            if oldValue?.highlightClip == nil
                && oldValue?.movie != nil { uploadButton(isActive: canUpload) }
        }
    }
    var url: (movie: URL?, highlightClip: URL?) {
        get {
            if let _url = _url { return _url }
            else { return (nil, nil) }
        }
        set { _url = newValue }
    }
    fileprivate var canUpload: Bool{
        get {
            if (_url?.movie != nil
                && _url?.highlightClip != nil
                && songTitleTF.text != "") {
                return true
            }
            return false
        }
    }
    // MARK: 
    @IBOutlet fileprivate weak var songTitleTF: UITextField!
    @IBOutlet fileprivate weak var uploadButton: RoundedButton!
    @IBOutlet fileprivate weak var coverSongSwitch: UISwitch!
    @IBOutlet fileprivate weak var captionTV: OutlinedTextView!
    fileprivate var videoPlayerVC: VideoVC!
    fileprivate lazy var movieEditor = UIVideoEditorController()
    fileprivate var locationManager: CLLocationManager!
    fileprivate var locValue: CLLocationCoordinate2D?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoVC {
            videoPlayerVC = segue.destination as! VideoVC
            videoPlayerVC.containerMaster = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLocationManager()
        self.tabBarController?.tabBar.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    @objc fileprivate func giveContainerGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentVideoEditVC))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        videoPlayerVC.gestureRecognizerView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func presentVideoEditVC(){
        if UIVideoEditorController.canEditVideo(atPath: url.movie!.absoluteString) {
            movieEditor.delegate = self
            let correctedURLString = (url.movie!.absoluteString).dropFirst("file:///".count)//needed or else NSURL=file:///file:/
            
            movieEditor.videoPath = String(correctedURLString)
            movieEditor.videoQuality = .typeHigh
            movieEditor.videoMaximumDuration = 30//seconds
            present(movieEditor, animated: true, completion: nil)
        } else { print("\nVIDEO CAN'T BE EDITED") }
    }
    
    fileprivate func setupNavigationBar(){
        if let navCtrlr = self.navigationController {
            navCtrlr.navigationBar.isHidden = false
            navCtrlr.title = ""
        }
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        uploadButton(isActive: canUpload)
    }
    
    fileprivate func uploadButton(isActive: Bool){
        uploadButton.isEnabled = canUpload
        if canUpload { uploadButton.backgroundColor = UIColor(named: "AppAccent") }
        else { uploadButton.backgroundColor = .lightGray }
    }
    
    @IBAction fileprivate func uploadButtonPressed(_ sender: UIButton){
        if canUpload {
            uploadButton.isEnabled = false
            let storageRef = Storage.storage().reference().child(FirebaseConfig.posts)
            
            upload(video: url.movie!.absoluteURL, to: storageRef.child("fullVideo\(UUID().uuidString)")){ fullVidStorageURL in
                self.upload(video: self.url.highlightClip!.absoluteURL, to: storageRef.child("highlightVideo/\(UUID().uuidString)")){ highlightVidStorageURL in
                    self.upload(thumbnail: self.videoPlayerVC.getVideoThumbnail()!, to: storageRef.child("thumbnails/\(UUID().uuidString)")){ thumbnailURL in
                        
                        let db = Database.database()
                        self.upload(videoURL: fullVidStorageURL, withHiglightVideoURL: highlightVidStorageURL, withThumbnail: thumbnailURL, to: db){
//                            self.navigationController?.popToRootViewController(animated: false)
//                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
            self.navigationController?.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    /**
     upload given URL to given online storage
     */
    fileprivate func upload(thumbnail: UIImage, to storageRef: StorageReference, onSuccess: @escaping (_ thumbnailURL: String) -> Void){
        let thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(thumbnailData!, metadata: metaData) {(metadata, error) in
            if error != nil { return }
            onSuccess(metadata!.downloadURL()!.absoluteString)
        }
    }
    
    
    /**
     uploads given URL to given online storage reference (put exact path!)
     */
    fileprivate func upload(video url: URL, to storageRef: StorageReference, onSuccess: @escaping (_ storageURL: String) -> Void){
        storageRef.putFile(from: url, metadata: nil){ (metadata, error) in
            if error == nil { onSuccess(metadata!.downloadURL()!.absoluteString) }
            else { return } //@todo possibly present an allert
        }
    }
    
    /**
     uploads to given database
     */
    fileprivate func upload(videoURL: String, withHiglightVideoURL highlightURL: String, withThumbnail thumbnailURL: String, to database: Database, onSuccess: @escaping () -> Void){
        guard let user = Auth.auth().currentUser?.uid else { return }
        var isCover = " "
        if coverSongSwitch.isOn { isCover = "cover " }
        let userPostsRef = database.reference().child(FirebaseConfig.posts)
        let newPostRef = userPostsRef.childByAutoId()
        let fileArray:[String : Any?] = ["thumbnailURL": thumbnailURL, "fullVideoURL": videoURL,
                                         "highlightClipURL": highlightURL, "songTitle": songTitleTF.text,
                                         "caption": captionTV.text, "latitude": locValue?.latitude,
                                         "longitude" : locValue?.longitude, "uid": user,
                                         "rankingPoints": 0, "likes": 0, "isCover": isCover]
        newPostRef.setValue(fileArray, withCompletionBlock: {(error, dbRef) in
            if error == nil { onSuccess() }
            else { print(error!); return }
        })
    }
}

extension UploadVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    /**
     called if UIVideoEditor succesfully saved new 30 second video
     */
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        url.highlightClip = URL(fileURLWithPath: editedVideoPath)
        dismiss(animated: true)
    }
    
    /**
     called if UIVideoEditor couldn't save new clip
     */
    func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
        print("\n\nSOMETHING WENT WRONG\n\n")
    }
}


extension UploadVC: CLLocationManagerDelegate{
    fileprivate func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
}
