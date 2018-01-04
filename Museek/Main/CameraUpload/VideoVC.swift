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
}


class VideoVC: UIViewController {
    var containerMaster: ContainerMaster?//is set when segued from camVC
    @IBOutlet weak var gestureRecognizerView: UIView!
    fileprivate var player: AVPlayer!
    fileprivate var avPlayerVC = AVPlayerViewController()
    
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
                self.view.addSubview(gestureRecognizerView)
            } else { player.play() }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayerVC.player?.play()
        //notification listens for video end, then resets time to 0
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem,
                                               queue: .main) { _ in
                                                self.player?.seek(to: kCMTimeZero)
                                                self.player?.play() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "videoVCLoaded"), object: nil)
    }
    
    deinit {
        player.pause()
        avPlayerVC.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     creates a UIImage from the first frame of given URL video
     */
    func getVideoThumbnail() -> UIImage? {
        var thumbnail: UIImage?
        do {
            let asset = AVURLAsset(url: containerMaster!.url.movie! , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        return thumbnail
    }
}
