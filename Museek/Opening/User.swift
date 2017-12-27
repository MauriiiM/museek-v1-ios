//
//  User.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/27/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import Foundation

class User {
    fileprivate let email: String
    fileprivate var username: String?
    fileprivate var password: String?
    fileprivate var location: Any?
    
    init(email: String){
        self.email = email
    }
    
    deinit {
        password = nil
    }
}
