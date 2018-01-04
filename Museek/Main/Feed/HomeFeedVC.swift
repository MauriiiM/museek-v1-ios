//
//  FeedVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/1/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeFeedVC: UITableViewController {
    fileprivate var retrievedPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 475
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let database = Database.database()
        retrievePostingData(from: database)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostingCell", for: indexPath) as! HomeFeedCell
        let currentPost = retrievedPosts[indexPath.row]
        cell.songTitleLabel.text = currentPost.songTitle
//        cell.profileImage.image = UIImage(named: "profile")
        cell.captionLabel.text = currentPost.caption
//        cell.videoThumbnail.image = currentPost.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell is VideoVC {
//            (cell as! HomeFeedCell).videoPlayerVC.removeFromParentViewController()
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedPosts.count
    }
    
    /**
     retrieves posts from database and creates post objects with database info
     */
    fileprivate func retrievePostingData(from database: Database){
        database.reference().child(FirebaseConfig.posts).observe(.childAdded, with: {dataSnapshot in
            if let postSnapDict = dataSnapshot.value as? [String: Any]{
                let post = Post.createPost(from: postSnapDict)
                self.retrievedPosts.insert(post, at: 0)
                self.tableView.reloadData()
            }
        })
    }
}
