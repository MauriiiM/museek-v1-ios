//
//  HomeFeedCellTableViewCell.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/2/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import AVKit

class HomeFeedCell: UITableViewCell {
    var post: Post? {
        didSet{
            updateCell()
        }
    }
    var user: User? {
        didSet{
           updateCellTop()
        }
    }
    fileprivate let videoThumbnailPlaceholder = UIImage(named: "video placeholder")!
    fileprivate let profileImagePlaceholder = UIImage(named: "default user photo")!
    @IBOutlet fileprivate weak var songTitleLabel: UILabel!
    @IBOutlet fileprivate weak var userName: UILabel!
    @IBOutlet fileprivate weak var profileImage: UIImageView!
    @IBOutlet fileprivate weak var videoThumbnail: UIImageView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var fireButton: RoundedButton!
    @IBOutlet fileprivate weak var commentButton: RoundedButton!
    @IBOutlet fileprivate weak var shareButton: RoundedButton!
    @IBOutlet  weak var videoView: UIView!
    fileprivate var avLayer: AVPlayerLayer?
    lazy var avPlayer = AVPlayer()
    var isPlaying = false {
        didSet{
            if !isPlaying { avPlayer.pause() }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
//                                               object: self.avPlayer.currentItem,
//                                               queue: .main) { _ in
//                                                self.avPlayer.seek(to: kCMTimeZero)
//                                                self.avPlayer.play() }
//        avPlayerVC.view.frame = videoView.frame
//        videoView = avPlayerVC.view
    }
    
    override func prepareForReuse() {
        profileImage.image = profileImagePlaceholder
        videoThumbnail.image = videoThumbnailPlaceholder
        avLayer?.removeFromSuperlayer()
        if isPlaying { avPlayer.pause() }
    }
    
    /**
     starts playing video when a cell is selected (user touches cell)
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //hide play icon which will be on top z layer
        avPlayer.play()
    }
    
    @IBAction fileprivate func likeButtonTapped(){
        print("LIKED")
    }
    
    @IBAction fileprivate func commentButtonTapped(){
        print("COMMENT")
    }
    
    @IBAction fileprivate func shareButtonTapped(){
        print("SHARING")
    }
    
    /**
     downloads and sets an image asynchronously
     */
    fileprivate func download(from urlString: String?, set image: UIImageView, withPlaceholder placeholder: UIImage){
        if let urlString = urlString{
            let url = URL(string: urlString)
            image.sd_setImage(with: url, placeholderImage: placeholder)
        }
    }
    
    /**
     loads and displays video, but doesn't start playing
     */
    fileprivate func loadHighlightVideo(){
        if let highlightURLString = post!.movieURL{
            let highlightURL = URL(string: highlightURLString)
            avPlayer = AVPlayer(url: highlightURL!)
            avLayer = AVPlayerLayer(player: avPlayer)
            avLayer!.frame = videoView.bounds
            avPlayer.externalPlaybackVideoGravity = .resizeAspectFill
//            avPlayer.
            videoView.layer.addSublayer(avLayer!)
        }
    }
    
    /**
     assigns all post info to visible UI cell
     */
    fileprivate func updateCell(){
        if let post = post {
            songTitleLabel.text = post.songTitle
            captionLabel.text = post.caption
            download(from: post.thumbnailURL, set: videoThumbnail, withPlaceholder: videoThumbnailPlaceholder)
            loadHighlightVideo()
        }
    }
    
    fileprivate func updateCellTop(){
        let formattedString = NSMutableAttributedString()
        formattedString.attributed("\(post!.isCover!)by ", font: "HelveticaNeue", size: 15).attributed(user!.username!, font: "HelveticaNeue-Medium", size: 15)
        userName.attributedText = formattedString
        download(from: user!.profileImageURL, set: self.profileImage, withPlaceholder: self.profileImagePlaceholder)
    }
}
