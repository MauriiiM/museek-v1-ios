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
 Allows a UIView to play a video by overriding its layer as the AVPlayer's layer
 */
class HomeFeedPlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
