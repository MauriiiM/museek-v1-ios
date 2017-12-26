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
   
//    var movieURL: URL {get set}
//    var highlightURL: URL{get set}
}

extension VideoVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
//        containerMaster?.highlightURL =
        containerMaster?.url.highlightClip = URL(fileURLWithPath: editedVideoPath)
    }
    
}

class VideoVC: UIViewController {
    var containerMaster: ContainerMaster?
    @IBOutlet weak fileprivate var topClearView: UIView!
    fileprivate var player: AVPlayer!
    fileprivate var avPlayerVC = AVPlayerViewController()
    fileprivate var movieEditor = UIVideoEditorController()
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayerVC.player?.play()
        //notification listens for video end, then resets time to 0
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem,
                                               queue: .main) { _ in
                                                self.player?.seek(to: kCMTimeZero)
                                                self.player?.play() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cm = containerMaster {
            if player == nil {
                player = AVPlayer(url: cm.url.movie!)
                avPlayerVC = AVPlayerViewController()
                avPlayerVC.showsPlaybackControls = false
                avPlayerVC.player = self.player
                avPlayerVC.view.frame = self.view.frame
                self.addChildViewController(avPlayerVC)
                avPlayerVC.view.addSubview(topClearView)
                self.view.addSubview(avPlayerVC.view)//allows for video to play outside of fullscreen
            } else { player.play() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        avPlayerVC.view.isUserInteractionEnabled = false
        
        movieEditor.delegate = self
        movieEditor.videoPath = containerMaster!.url.movie!.absoluteString
        movieEditor.videoQuality = .typeHigh
        
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
        print("\n\\nVIDEO WAS TAPPED!!!!!!!\n\n")
        present(movieEditor, animated: true, completion: nil)
    }
}
