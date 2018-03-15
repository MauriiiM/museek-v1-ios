//
//  HomeFeedVideoView.swift
//  Museek
//
//  Created by Mauricio Monsivais on 2/22/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import AVKit

/**
 Allows a UIView to play a video by overriding its layer as the AVPlayer's layer.
 Idea taken directly from Apple's API
 */
class HomeFeedPlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
            startReplayListener()
        }
    }
    fileprivate var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    

    /**
     Listen for the player's "AVPlayerItemDidPlayToEndTime" notification. When recieved, rewind
     to video's 0.0 time and starts playing.
     @TODO test with more than one video in feed
     */
    fileprivate func  startReplayListener(){
        //notification listens for video end, then resets time to 0
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem,
                                               queue: .main) { _ in
                                                self.player?.seek(to: kCMTimeZero)
                                                self.player?.play() }
    }
}
