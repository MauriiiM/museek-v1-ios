//
//  FollowAPI.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/18/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SupportAPI{
    var REF_SUPPORTERS = Database.database().reference().child("Supporters")
    var REF_SUPPORTING = Database.database().reference().child("Supporting")

    func isSupportingUser(withID id: String, result: @escaping (Bool) -> ()){
        REF_SUPPORTERS.child(id).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value){
            snapshot in
            if let _ = snapshot.value as? NSNull{
                result(false)
            } else { result(true) }
        }
        return
    }
    
    /**
     Will add current user to passed user's supporters list and add passed user
     to current user's supporting list
     */
    func supportUser(withID id: String){
        REF_SUPPORTERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        REF_SUPPORTING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    /**
     Will remove current user from passed user's supporters list and remove passed user
     from current user's supporting list
     */
    func stopSupportingUser(withID id: String){
        REF_SUPPORTERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        REF_SUPPORTING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
}

