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
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var retrievedPosts = [Post]()
    fileprivate var retrievedUsers = [User]()
    fileprivate var currentlyPlayingIndexPath : IndexPath?{
        didSet{
            if let lastIndexPath = oldValue, lastIndexPath != currentlyPlayingIndexPath{
                let lastCell = tableView.cellForRow(at: lastIndexPath) as! HomeFeedCell
                lastCell.isPlaying = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 475
        self.tableView.rowHeight = UITableViewAutomaticDimension
        retrievePostData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let currentlyPlayingIndexPath = IndexPath(row: 0, section: 0)
//        tableView.selectRow(at: currentlyPlayingIndexPath, animated: true, scrollPosition: .none)
//    }
    
    /**
     pauses video so it won't play in the background
     */
    override func viewWillDisappear(_ animated: Bool) {
        if let currentIndex = currentlyPlayingIndexPath{
            (tableView.cellForRow(at: currentIndex) as! HomeFeedCell).isPlaying = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\nmemory warning in homeFeedVc\n")
    }
        
    /**
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostingCell", for: indexPath) as! HomeFeedCell
        let currentPost = retrievedPosts[indexPath.row]
        let currentUser = retrievedUsers[indexPath.row]
        cell.post = currentPost
        cell.user = currentUser
        return cell
    }
    
    /**
     called when user touches a cell.
     Used to auto-center cell on screen and play highlight video
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        currentlyPlayingIndexPath = indexPath
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        refreshControl?.endRefreshing()
        return retrievedPosts.count
    }
    
    fileprivate func fetchUser(withUID uid: String, completed: @escaping () -> Void){
        Api.User.observeUser(withUID: uid){ user in
            self.retrievedUsers.insert(user, at: 0)
            completed()
        }
    }
    
    /**
     retrieves posts from database and creates post objects with database info
     */
    fileprivate func retrievePostData(){
        Api.Post.observePost(){ post in
            self.fetchUser(withUID: post.uid!){
                self.retrievedPosts.insert(post, at: 0)
                self.tableView.reloadData()
                //self.activityIndicator.stopAnimating()
            }
        }
    }
}
