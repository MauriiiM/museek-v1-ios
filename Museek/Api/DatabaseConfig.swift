//
//  FirebaseConfig.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/30/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import Foundation

class DatabaseConfig {
//    enum posts: String {
//        case fullVideo = "fullVideo"
//        case postHighlightClip  = "highlightClip"
//    }
    static let posts = "posts"
    static let users = "users"
    static let supporters = "supporters"
    static let supporting = "supporting"
    static let postHighlightClip = "highlightClip"
    struct DATABASE{
        static let ROOT_URL_REF = "https://museek-fb1d.firebaseio.com/"
    }
    
//    struct STORAGE{
//        static let ROOT_URL_REF = "gs://museek-fb1d.appspot.com/"
//    }
}
