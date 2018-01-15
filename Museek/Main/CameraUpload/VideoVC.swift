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
    var videoViewLoaded: Bool? {get set}
}


class VideoVC: UIViewController {
    var containerMaster: ContainerMaster?//is set when segued from camVC
    var displaysControls: Bool{
        get{ return avPlayerVC.showsPlaybackControls }
        set{ avPlayerVC.showsPlaybackControls = newValue }
    }
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
        if containerMaster != nil { containerMaster!.videoViewLoaded = true }
    }
    
    deinit {
        player.pause()
        avPlayerVC.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     creates a UIImage from the first frame of given URL video
     @TODO this needs to be moved to a different class because it shouldn't take
     a video url, in this class it should just be the video it's playing
     */
    func getVideoThumbnail() -> UIImage? {
        var thumbnail: UIImage?
        if let highlighVid = containerMaster?.url.highlightClip{
            do {
                let asset = AVURLAsset(url: highlighVid , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                thumbnail = UIImage(cgImage: cgImage)
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
        return thumbnail
    }
}
