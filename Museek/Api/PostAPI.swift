//
//  PostAPI.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/15/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import FirebaseDatabase

class PostAPI{
    let REF_POST = Database.database().reference().child(DatabaseConfig.posts)
    
    func observePost(completionHandler: @escaping (Post) -> Void){
        REF_POST.observe(.childAdded){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(from: dict, key: snapshot.key)
                completionHandler(newPost)
            }
        }
    }
}
