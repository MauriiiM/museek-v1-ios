//
//  UsersAPI.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UsersAPI{
    let REF_USERS = Database.database().reference().child("users")
    
    var REF_CURRENT_USER: DatabaseReference?{
        guard let currentUSer = Auth.auth().currentUser else { return nil }
        return REF_USERS.child(currentUSer.uid)
    }
}
