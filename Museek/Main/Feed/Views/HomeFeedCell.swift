//
//  HomeFeedCellTableViewCell.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/2/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase

class HomeFeedCell: UITableViewCell {
    fileprivate let videoThumbnailPlaceholder = UIImage(named: "video placeholder")!
    fileprivate let profileImagePlaceholder = UIImage(named: "default user photo")!
    fileprivate var postRef: DatabaseReference?
    fileprivate var fireRefHandler: UInt!
    //MARK: IB vars
    @IBOutlet fileprivate weak var songTitleLabel: UILabel!
    @IBOutlet fileprivate weak var userName: UILabel!
    @IBOutlet fileprivate weak var profileImage: UIImageView!
    @IBOutlet fileprivate weak var videoThumbnail: UIImageView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var genreLabel: UILabel!
    @IBOutlet fileprivate weak var fireCountButton: UIButton!
    @IBOutlet fileprivate weak var fireButton: RoundedButton!
    @IBOutlet fileprivate weak var commentButton: RoundedButton!
    @IBOutlet fileprivate weak var shareButton: RoundedButton!
    //MARK: Model vars
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
    //MARK: avplayer vars
    var isPlaying = false {
        didSet{
            if !isPlaying { avPlayer.pause() }
        }
    }
    @IBOutlet weak var videoView: HomeFeedPlayerView!
    fileprivate var avPlayer: AVPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = profileImagePlaceholder
        videoThumbnail.image = videoThumbnailPlaceholder
        if isPlaying { avPlayer.pause() }
        Api.Post.REF_POST.child(post!.id!).removeObserver(withHandle: fireRefHandler)
    }
    
    /**
     starts playing video when a cell is selected (user touches cell)
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //hide play icon which will be on top z layer
        if avPlayer != nil { avPlayer.play() }
        
    }
    
    @IBAction fileprivate func likeButtonTapped(){
        postRef = Api.Post.REF_POST.child(post!.id!)
        incrementFireCount(forReference: postRef!)
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
     
     */
    fileprivate func incrementFireCount(forReference ref: DatabaseReference){
        ref.runTransactionBlock({ data in
            if var post = data.value as? [String: AnyObject], let uid = Api.User.CURRENT_USER?.uid{
                var fires: Dictionary<String, Bool>
                fires = post["fires"] as? [String: Bool] ?? [:]
                var fireCount = post["fireCount"] as? Int ?? 0
                if let _ = fires[uid]{
                    fireCount -= 1
                    fires.removeValue(forKey: uid)
                } else {
                    fireCount += 1
                    fires[uid] = true
                }
                post["fires"] = fires as AnyObject?
                post["fireCount"] = fireCount as AnyObject?
                data.value = post
                // return TransactionResult.success(withValue: data)
            }
            return TransactionResult.success(withValue: data)
        }){ (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = snapshot?.value as? [String: Any]{
                let post = Post.transformPost(from: dict, key: snapshot!.key)
                self.updateFire(post)
            }
        }
    }
    
    /**
     loads and displays video, but doesn't start playing
     */
    func loadHighlightVideo(){
        if avPlayer == nil {
            if let highlightURLString = post!.highlightURL{
                let highlightURL = URL(string: highlightURLString)
                avPlayer = AVPlayer(url: highlightURL!)
                videoView.player = avPlayer
                videoThumbnail.isHidden = true
                avPlayer.play()
            }
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
//            loadHighlightVideo()
            
            //needed for cell reuse
            Api.Post.REF_POST.child(post.id!).observeSingleEvent(of: .value){ snapshot in
                if let dict = snapshot.value as? [String: Any]{
                    let post = Post.transformPost(from: dict, key: snapshot.key)
                    self.updateFire(post)
                }
            }
            fireRefHandler = Api.Post.REF_POST.child(post.id!).observe(.childChanged){ snapshot in
                if let count = snapshot.value as? Int{
                    self.fireCountButton.setTitle("\(count)", for: .normal)
                }
            }
        }
    }
    
    fileprivate func updateFire(_ post: Post){
        let fireImage = post.isFire == nil || !post.isFire! ? "fire" : "fire (filled)"
        fireButton.imageView?.image = UIImage(named: fireImage)
       
        let fireCount = post.fireCount == nil || post.fireCount! == 0 ? " " : "\(post.fireCount!)"
        fireCountButton.setTitle(fireCount, for: .normal)
    }
    
    fileprivate func updateCellTop(){
        let formattedString = NSMutableAttributedString()
        formattedString.attributed("\(post!.isCover!)by ", font: "HelveticaNeue", size: 15).attributed(user!.username!, font: "HelveticaNeue-Medium", size: 15)
        userName.attributedText = formattedString
        download(from: user!.profileImageURL, set: self.profileImage, withPlaceholder: self.profileImagePlaceholder)
    }
}
