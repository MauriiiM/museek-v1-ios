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

class UploadVC: UIViewController, ContainerMaster {
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
                /*&& _url?.highlightClip != nil*/
                && songTitleTF.text != "") {
                return true
            }
            return false
        }
    }
    
    @IBOutlet fileprivate weak var songTitleTF: UITextField!
    @IBOutlet fileprivate weak var uploadButton: RoundedButton!
    @IBOutlet fileprivate weak var coverSongSwitch: UISwitch!
    @IBOutlet fileprivate weak var captionTV: OutlinedTextView!
    fileprivate var videoEditVC: VideoVC!
    fileprivate var _highlight: URL?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoVC {
            videoEditVC = segue.destination as! VideoVC
            videoEditVC.containerMaster = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    fileprivate func uploadButton(isActive: Bool){
            uploadButton.isEnabled = canUpload
            if canUpload {
                uploadButton.backgroundColor = UIColor(named: "AppAccent")
            } else {
                uploadButton.backgroundColor = .lightGray
            }
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
    
    @IBAction fileprivate func uploadButtonPressed(_ sender: UIButton){
        if canUpload {
            uploadButton.isEnabled = false//
            let uploadUID = UUID().uuidString
            //            let storageRef = Storage.storage().reference(forURL: FirebaseConfig.STORAGE.ROOT_URL_REF)
            let storageRef = Storage.storage().reference().child(FirebaseConfig.posts).child(uploadUID)
            //            let highlightRef = storageRef.child(FirebaseConfig.STORAGE.postHighlightClip)
            
            storageRef.putFile(from: _url!.movie!, metadata: nil, completion: {(metadata, error) in
                if error != nil { return }
                else {
                    let videoStorageURL = metadata?.downloadURL()?.absoluteString
                    let db = Database.database()
                    self.upload(videoData: videoStorageURL!, to: db)
                }
            })
        }
    }
    
    fileprivate func upload(videoData url: String, to database: Database){
        let postsRef = database.reference().child(FirebaseConfig.posts)
        let newPostId = postsRef.childByAutoId().key
        let newPostRef = postsRef.child(newPostId)
        let fileArray:[String : Any?] = ["fullVideoURL" : url, "songTitle": songTitleTF.text, "caption": captionTV.text]
        newPostRef.setValue(fileArray, withCompletionBlock: {(error, dbRef) in
            if error != nil { print(error!); return }
            else {
                self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 0
            }
        })
    }
}
