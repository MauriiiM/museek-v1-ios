//
//  UploadVCViewController.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/15/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, ContainerMaster {
    @IBOutlet weak var songTitleTF: UITextField!
    @IBOutlet weak var coverSongSwitch: UISwitch!
    @IBOutlet weak var descriptionTV: UITextView!
//    @IBOutlet weak var videoView: UIView!
    fileprivate var videoEditVC: VideoEditVC!
    fileprivate var _movieURL: URL?
    var movieURL: URL {
        get { return _movieURL! }
        set(url){ _movieURL = url }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoEditVC {
            videoEditVC = segue.destination as! VideoEditVC
            videoEditVC.containerMaster = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
