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
    var thumbnail: UIImage? {get set}
}

extension VideoVC: UINavigationControllerDelegate, UIVideoEditorControllerDelegate{
    
    /**
     called if UIVideoEditor succesfully saved new 30 second video
     */
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        containerMaster?.url.highlightClip = URL(fileURLWithPath: editedVideoPath)
//        containerMaster?.thumbnail = getThumbnailFrom(path: URL(fileURLWithPath: editedVideoPath))
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
        
        movieEditor.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.videoWasTapped))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        topClearView.addGestureRecognizer(tapGesture)
        
        containerMaster?.thumbnail = getThumbnailFrom(path: containerMaster!.url.movie!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    deinit {
        player.pause()
        avPlayerVC.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     creates a UIImage from the first frame of given URL video
     */
    fileprivate func getThumbnailFrom(path url: URL) -> UIImage? {
        var thumbnail: UIImage?
        do {
            let asset = AVURLAsset(url: url , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        return thumbnail
    }
    
    @objc fileprivate func videoWasTapped(){
        if UIVideoEditorController.canEditVideo(atPath: containerMaster!.url.movie!.absoluteString) {
            movieEditor.videoPath = containerMaster!.url.movie!.absoluteString
            movieEditor.videoQuality = .typeHigh
            movieEditor.videoMaximumDuration = 30//seconds
            present(movieEditor, animated: true, completion: nil)
        } else { print("\nVIDEO CAN'T BE EDITED") }
    }
}
