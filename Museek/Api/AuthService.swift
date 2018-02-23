//
//  AuthService.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/24/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Firebase
import FirebaseAuth

class AuthService {
    /**
     will create a new Firebase-authenticated user and add them to the database
     */
    static func create(user: User, withPassword pswrd: String, onSuccess: @escaping (Firebase.User?) -> Void, onError: @escaping (Error) -> Void){
        Auth.auth().createUser(withEmail: user.email, password: pswrd, completion: {
            (newUser, error) in
            if error == nil {
                let userRef = Database.database().reference().child("users/\(newUser!.uid)")
                userRef.setValue(["username": user.username, "email": user.email])
                onSuccess(newUser)
            } else {
                onError(error!)
            }
        })
    }
    
    /**
     will attempt to sign in a user
     */
    static func signIn(withEmail email: String, password: String, completionHandler: @escaping (Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){
            (user, error) in completionHandler(error)
        }
    }
    
    static func signOut(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void){
        do{
            try Auth.auth().signOut()
            onSuccess()
        } catch let logoutError {
            onError(logoutError)
        }
    }
}
