//
//  Post.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/1/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Foundation

class Post {
    var songTitle: String?
    var isCover: String?
    var thumbnailURL: String?
    var movieURL: String?
    var highlightURL: String?
    var caption: String?
    var cordinates: (String?, String?)?
    var uid: String? //user id
    var id: String?// post id
    var fireCount: Int?
    var fires: Dictionary<String, Any>?
    var isFire: Bool?
}
extension Post{
    class func transformPost(from dictionary: [String: Any], key: String)->Post{
        let post = Post()
        post.id = key
        post.caption = dictionary["caption"] as? String
        post.thumbnailURL = dictionary["thumbnailURL"] as? String
        post.movieURL = dictionary["fullVideoURL"] as? String
        post.highlightURL = dictionary["highlightVideoURL"] as? String
        post.songTitle = dictionary["songTitle"] as? String
        post.isCover = dictionary["isCover"] as? String
        post.cordinates = (dictionary["latitude"], dictionary["longitude"]) as? (String?, String?)
        post.uid = dictionary["uid"] as? String
        post.fireCount = dictionary["fireCount"] as? Int
        post.fires = dictionary["fires"] as? Dictionary<String, Any>
        if post.fires != nil {
            post.isFire = post.fires![Api.User.CURRENT_USER!.uid] != nil
        }
        
        return post
    }
}
