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
    var location: Any?
    var username: String?

    init(withEmail email: String){
        self.email = email
    }
    
    deinit {
//        password = nil
    }
    
    func changeEmail(to newEmail: String){
        email = newEmail
    }
}
