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

class HomeFeedVC: UITableViewController {
    fileprivate var retrievedPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database = Database.database()
        retrievePostingData(from: database)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostingCell", for: indexPath)
        cell.backgroundColor = UIColor(named: "AppMain")
        cell.textLabel?.text = retrievedPosts[indexPath.row].songTitle
        return cell
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
