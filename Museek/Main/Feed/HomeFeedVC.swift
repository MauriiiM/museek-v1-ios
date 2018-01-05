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
    fileprivate var retrievedUsers = [User]()
    fileprivate var currentlyPlayingIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 475
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let database = Database.database()
        retrievePostingData(from: database)
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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedPosts.count
        refreshControl?.endRefreshing()
    }
    
    fileprivate func fetchUser(uid: String, completed: @escaping () -> Void){
        Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value, with: {
            dataSnapshot in
            let dictionary = dataSnapshot.value as? [String: Any]
            let user = User.transformUser(with: dictionary!)
            self.retrievedUsers.insert(user, at: 0)
            completed()
        })
    }
    
    /**
     retrieves posts from database and creates post objects with database info
     */
    fileprivate func retrievePostingData(from database: Database){
        database.reference().child(FirebaseConfig.posts).observe(.childAdded)
        { dataSnapshot in
            if let postSnapDict = dataSnapshot.value as? [String: Any]{
                let post = Post.transformPost(from: postSnapDict)
                self.fetchUser(uid: post.uid!){
                    self.retrievedPosts.insert(post, at: 0)
                    self.tableView.reloadData()
                }
                
//                if self.refreshControl!.isRefreshing {
//                    self.refreshControl?.endRefreshing()
//                }
            }
        }
    }
}
