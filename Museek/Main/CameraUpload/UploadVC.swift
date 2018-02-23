//
//  UploadVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/15/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import CoreLocation

class UploadVC: UIViewController, ContainerMaster {
    //MARK: Container MAster protocol vars
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
    var vidCoordinates: CLLocationCoordinate2D?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoVC {
            videoPlayerVC = segue.destination as! VideoVC
            videoPlayerVC.containerMaster = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    fileprivate func createUploadDict(fullURL: String, highlightURL: String, thumbnailURL: String) -> [String: Any?]{
        let user = Api.User.CURRENT_USER?.uid
        var isCover = " "
        if coverSongSwitch.isOn { isCover = "cover " }
        let uploadDictonary: [String : Any?] =
            ["fullVideoURL": fullURL, "highlightVideoURL": highlightURL,
             "thumbnailURL": thumbnailURL, "songTitle": self.songTitleTF.text,
             "caption": self.captionTV.text, "uid": user, "isCover": isCover,
             "latitude": self.vidCoordinates!.latitude,
             "longitude": self.vidCoordinates!.longitude]
        return uploadDictonary
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
    
    @IBAction fileprivate func titleChanged(_ sender: UITextField) {
        uploadButton(isActive: canUpload)
    }
    
    fileprivate func uploadButton(isActive: Bool){
        uploadButton.isEnabled = canUpload
        if canUpload { uploadButton.backgroundColor = UIColor(named: "AppAccent") }
        else { uploadButton.backgroundColor = .lightGray }
    }
    
    @IBAction fileprivate func uploadButtonPressed(_ sender: UIButton){
        if canUpload {
            uploadMedia{ error in
                if error == nil {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    /**
     Uploads everything collected from user regarding their video to storage and database. First uploads
     full video to storage, then highlight video to sotrage, then highlight thumbnail to storage, and
     finally, uploads all 3 + text field inputs to database.
     */
    fileprivate func uploadMedia(completion: @escaping (Error?) -> Void){
        uploadButton.isEnabled = false
        let storageRef = UploadService.REF_STO_POSTS.child(DatabaseConfig.posts)
        
        UploadService.upload(video: url.movie!.absoluteURL, with: nil, to: storageRef.child("fullVideo/\(UUID().uuidString)"))
        { fullVidStorageURL in
            
            UploadService.upload(video: self.url.highlightClip!.absoluteURL, with: nil, to: storageRef.child("highlightVideo/\(UUID().uuidString)"))
            { highlightVidStorageURL in
                
                guard let thumbnailData = UIImageJPEGRepresentation(self.videoPlayerVC.getVideoThumbnail()!, 0.75) else { return }
                
                UploadService.upload(image: thumbnailData, to: storageRef.child("thumbnails/\(UUID().uuidString)"))
                { thumbnailStorageURL in
                    let uploadData = self.createUploadDict(fullURL: fullVidStorageURL,
                                                           highlightURL: highlightVidStorageURL, thumbnailURL: thumbnailStorageURL)
                    Api.Post.upload(data: uploadData){
                        completion(nil)//@todo correct to be 2 args succes
                    }
                }
            }
        }
    }
}

extension UploadVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    /**
     called if UIVideoEditor succesfully saved new 30 second video
     @TODO this saves in as .mov file, convert to .mp4!!!
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
