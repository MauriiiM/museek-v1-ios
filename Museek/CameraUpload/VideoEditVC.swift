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
    var movieURL: URL {get set}
}

extension VideoEditVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    
}

class VideoEditVC: UIViewController {
    var containerMaster: ContainerMaster?
    fileprivate var player: AVPlayer!
    fileprivate var avPlayerVC = AVPlayerViewController()
    
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
                player = AVPlayer(url: cm.movieURL)
                avPlayerVC = AVPlayerViewController()
                avPlayerVC.showsPlaybackControls = false
                avPlayerVC.player = self.player
                avPlayerVC.view.frame = self.view.frame
                self.addChildViewController(avPlayerVC)
                self.view.addSubview(avPlayerVC.view)//allows for video to play outside of fullscreen
            }
        } else { player.play() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.videoWasTapped))
//        tapGesture.delegate = self as? UIGestureRecognizerDelegate
//        avPlayerVC.view.addGestureRecognizer(tapGesture)
        
        print("\n\n\(String(describing: avPlayerVC.view.gestureRecognizers))\n")
    }
    
    deinit {
        player.pause()
        avPlayerVC.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func videoWasTapped(){
        print("\n\nVIEW WAS TAPPED!!!!!!!\n\n")
    }
}
