//
//  User.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/27/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import Foundation

class User {
    var email: String
    var coordinates: (String, String)?
    var username: String?
    var profileImageURL: String?
    
    /**
     Initializes a new user with given email. Function is needed and used in signup process.
     */
    init(withEmail email: String){
        self.email = email
    }
    
    func changeEmail(to newEmail: String){
        email = newEmail
    }
}

extension User{
    static func transformUser(with dict: [String: Any]) -> User{
        let user = User(withEmail: dict["email"] as! String)
        user.username = dict["username"] as? String
        user.profileImageURL = dict["profileImageURL"] as? String
        return user
    }
}
