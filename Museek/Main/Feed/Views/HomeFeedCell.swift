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
        avPlayer.pause()
//        avPlayerVC.player = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    
    fileprivate func download(from urlString: String?, set image: UIImageView, withPlaceholder placeholder: UIImage){
        if let urlString = urlString{
            let url = URL(string: urlString)
            image.sd_setImage(with: url, placeholderImage: placeholder)
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
            if let movieURLString = post.movieURL{
                let movieURL = URL(string: movieURLString)
                avPlayer = AVPlayer(url: movieURL!)
                avLayer = AVPlayerLayer(player: avPlayer)
                avLayer!.frame = videoThumbnail.frame
                avLayer?.frame.size.width = UIScreen.main.bounds.width
//                self.contentView.layer.addSublayer(avLayer!)
                videoView.layer.addSublayer(avLayer!)
                videoThumbnail.image = nil
                avPlayer.play()
            }
        }
    }
    
    fileprivate func updateCellTop(){
        let formattedString = NSMutableAttributedString()
        formattedString.attributed("\(post!.isCover!)by ", font: "HelveticaNeue", size: 15).attributed(user!.username!, font: "HelveticaNeue-Medium", size: 15)
        userName.attributedText = formattedString
        download(from: user!.profileImageURL, set: self.profileImage, withPlaceholder: self.profileImagePlaceholder)
    }
}
