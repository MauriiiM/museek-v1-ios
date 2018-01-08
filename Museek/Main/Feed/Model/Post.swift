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
    var caption: String?
    var cordinates: (String?, String?)?
    var uid: String?
}
extension Post{
    class func transformPost(from dictionary: [String: Any])->Post{
        let post = Post()
        post.caption = dictionary["caption"] as? String
        post.thumbnailURL = dictionary["thumbnailURL"] as? String
        post.movieURL = dictionary["fullVideoURL"] as? String
        post.songTitle = dictionary["songTitle"] as? String
        post.isCover = dictionary["isCover"] as? String
        post.cordinates = (dictionary["latitude"], dictionary["longitude"]) as? (String?, String?)
        post.uid = dictionary["uid"] as? String
        return post
    }
}
