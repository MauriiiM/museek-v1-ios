//
//  UploadVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/15/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, ContainerMaster {
    fileprivate var _url: (movie: URL?, highlightClip: URL?)?
    var url: (movie: URL?, highlightClip: URL?) {
        get {
            if let _url = _url { return _url }
            else {
                return (nil, nil) }
        }
        set(passedUrl){
            _url = passedUrl
        }
    }
    
    @IBOutlet weak var songTitleTF: UITextField!
    @IBOutlet weak var coverSongSwitch: UISwitch!
    @IBOutlet weak var descriptionTV: UITextView!
    fileprivate var videoEditVC: VideoVC!
    fileprivate var _highlight: URL?
    
//    var highlightURL: URL
//    fileprivate var _movieURL: URL?
//    var movieURL: URL {
//        get { return _movieURL! }
//        set(url){ _movieURL = url }
//    }
//
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupNavigationBar(){
        if let navCtrlr = self.navigationController {
            navCtrlr.navigationBar.isHidden = false
            navCtrlr.title = ""
            self.navigationItem.rightBarButtonItem = setupUploadButton()
            // navCtrlr.childViewControllers.last?.navigationItem.backBarButtonItem?.title = "Camera"
        }
    }
    
    fileprivate func setupUploadButton() -> UIBarButtonItem {
        let buttonAccent = UIColor(named: "AppAccent")!
        let button = RoundedButton(frame: CGRect(x: 0, y: 0, width: 50, height: 5))
        button.setTitle("Share", for: .normal)
        button.setTitleColor(buttonAccent, for: .normal)
        button.setTitleColor(UIColor(named: "AppMain"), for: .highlighted)
        button.borderWidth = 1
        button.borderColor = buttonAccent
        button.cornerRadius = 7
        button.addTarget(self, action: #selector(self.uploadButtonPressed(_:)), for: .touchUpInside)
        let uploadButton = UIBarButtonItem(customView: button)
        uploadButton.isEnabled = true
        return uploadButton
    }
    
    /**
     called when upload button in navigation bar is pressed.
     Uploads video (and accompaning information) to Firebase.
     */
    @objc func uploadButtonPressed(_ sender: UIBarButtonItem){
        print("\n\nupload!\n\n")
    }
}
