//
//  UsersAPI.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Firebase
import FirebaseDatabase

class UsersAPI{
    let REF_USERS = Database.database().reference().child(DatabaseConfig.users)
    var CURRENT_USER = Auth.auth().currentUser
    
    var REF_CURRENT_USER: DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return REF_USERS.child(currentUser.uid)
    }
    
    /**
     will observe any changes to specified current user
     */
    func observeCurrentUser(completionHandler: @escaping (User) -> Void){
        guard let currentUser = CURRENT_USER else { return }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(with: dict, key: snapshot.key)
                completionHandler(user)
            }
        }
    }
    
    /**
     will observe any changes to specified user's (by given id) path (eg.
     */
    func observeUser(withUID uid: String, completionHandler: @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(with: dict, key: snapshot.key)
                completionHandler(user)
            }
        }
    }
    
    /**
     Uploads given online storage url as current user's profile image.
     */
    func update(image url: String, onSuccess: @escaping () -> Void){
        let databaseRef = REF_CURRENT_USER!.child("profileImageURL")
        databaseRef.setValue(url, withCompletionBlock: {(error, dbRef) in
            if error == nil { onSuccess() }
            else { print(error!); return }
        })
    }
}
