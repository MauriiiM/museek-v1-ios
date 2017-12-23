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
            player = AVPlayer(url: cm.movieURL)
            avPlayerVC = AVPlayerViewController()
            avPlayerVC.showsPlaybackControls = false
            avPlayerVC.player = self.player
            avPlayerVC.view.frame = self.view.frame
            self.addChildViewController(avPlayerVC)
            self.view.addSubview(avPlayerVC.view)//allows for video to play outside of fullscreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
