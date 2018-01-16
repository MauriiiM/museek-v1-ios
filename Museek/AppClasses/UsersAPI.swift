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
    fileprivate let REF_USERS = Database.database().reference().child(DatabaseConfig.users)
    
    var REF_CURRENT_USER: DatabaseReference?{
        guard let currentUSer = Auth.auth().currentUser else { return nil }
        return REF_USERS.child(currentUSer.uid)
    }
    
    func observeUser(withUID uid: String, completionHandler: @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(with: dict)
                completionHandler(user)
            }
        }
    }
}
