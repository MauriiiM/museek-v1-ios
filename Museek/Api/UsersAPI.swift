//
//  UsersAPI.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UsersAPI{
    let REF_USERS = Database.database().reference().child(DatabaseConfig.users)
    var CURRENT_USER = Auth.auth().currentUser
    
    var REF_CURRENT_USER: DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return REF_USERS.child(currentUser.uid)
    }
    
    func observeCurrentUser(completionHandler: @escaping (User) -> Void){
        guard let currentUser = CURRENT_USER else { return }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(with: dict, key: snapshot.key)
                completionHandler(user)
            }
        }
    }
    
    func observeUser(withUID uid: String, completionHandler: @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value){ snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(with: dict, key: snapshot.key)
                completionHandler(user)
            }
        }
    }
    
    /**
     will create a new Firebase-authenticated user and add them to the database
     */
    func create(user: User, withPassword pswrd: String, onSuccess: @escaping (Firebase.User?, Error?) -> Void){
        Auth.auth().createUser(withEmail: user.email, password: pswrd, completion: {
            (newUser, error) in
            if error == nil {
                let userRef = Database.database().reference().child("users/\(newUser!.uid)")
                userRef.setValue(["username": user.username, "email": user.email])
            }
                onSuccess(newUser, error)
            })
    }
}
