//
//  VideoEditVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/22/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol ContainerMaster {
    var url: (movie: URL?, highlightClip: URL?) {get set}
    var canUpload: Bool {get set}
}

extension VideoVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    
    /**
     called if UIVideoEditor succesfully saved new 30 second video
     */
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        containerMaster?.url.highlightClip = URL(fileURLWithPath: editedVideoPath)
//        print("\n\noriginalURL=\(containerMaster?.url.movie)\nclipURL=\(containerMaster?.url.highlightClip)\n\n")
        containerMaster?.canUpload = true
    }
    
    /**
     called if UIVideoEditor couldn't save new clip
     */
    func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
        print("\n\nSOMETHING WENT WRONG\n\n")
    }
}

class VideoVC: UIViewController {
    var containerMaster: ContainerMaster?//is set when segued from camVC
    @IBOutlet weak fileprivate var topClearView: UIView!
    fileprivate var player: AVPlayer!
    fileprivate var avPlayerVC = AVPlayerViewController()
    fileprivate var movieEditor = UIVideoEditorController()

    
    override func viewWillAppear(_ animated: Bool) {
        if let cm = containerMaster {
            if player == nil {
                player = AVPlayer(url: cm.url.movie!)
                avPlayerVC = AVPlayerViewController()
                avPlayerVC.showsPlaybackControls = false
                avPlayerVC.player = self.player
                avPlayerVC.view.frame = self.view.frame
                self.addChildViewController(avPlayerVC)
                self.view.addSubview(avPlayerVC.view)//allows for video to play outside of fullscreen
                self.view.addSubview(topClearView)
            } else { player.play() }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("VIEW APPEARED")
        avPlayerVC.player?.play()
        //notification listens for video end, then resets time to 0
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem,
                                               queue: .main) { _ in
                                                self.player?.seek(to: kCMTimeZero)
                                                self.player?.play() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        avPlayerVC.view.isUserInteractionEnabled = false
        
        movieEditor.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.videoWasTapped))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        topClearView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    deinit {
        player.pause()
        avPlayerVC.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func videoWasTapped(){
        if UIVideoEditorController.canEditVideo(atPath: containerMaster!.url.movie!.absoluteString) {
            movieEditor.videoPath = containerMaster!.url.movie!.absoluteString
            movieEditor.videoQuality = .typeHigh
            movieEditor.videoMaximumDuration = 30//seconds
            present(movieEditor, animated: true, completion: nil)
        } else { print("\nVIDEO CAN'T BE EDITEd") }
    }
}
