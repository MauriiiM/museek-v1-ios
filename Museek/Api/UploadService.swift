//
//  UploadService.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/24/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class UploadService{
    static let REF_STO_POSTS = Storage.storage().reference().child("posts")
    static let REF_STO_PROFILE_IMAGE = Storage.storage().reference().child("profileImages")
    
    
    
    /**
     Uploads given image data, then uploads to given online storage as a jpeg.
     */
    static func upload(image data: Data, to storageRef: StorageReference, onSuccess: @escaping (_ thumbnailURL: String) -> Void){
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(data, metadata: metaData) {(metadata, error) in
            if error != nil { return }
            onSuccess(metadata!.downloadURL()!.absoluteString)
        }
    }
    
    /**
     Uploads given URL to given online storage reference (put exact storage path!).
     */
    static func upload(video url: URL, with metadata: StorageMetadata?, to storageRef: StorageReference, onSuccess: @escaping (_ storageURL: String) -> Void){
        storageRef.putFile(from: url, metadata: metadata){ (metadata, error) in
            if error == nil { onSuccess(metadata!.downloadURL()!.absoluteString) }
            else { return } //@todo possibly present an allert
        }
    }
    
    /**
     Uploads an item as the value, to database location as the key.
     If you want to add it as a child of location (e.g. new profile image to
     current user) the database reference should be /parent/newChildKey
     */
    static func upload(data item: String, to databaseRef: DatabaseReference, onSuccess: @escaping () -> Void){
        databaseRef.setValue(item, withCompletionBlock: {(error, dbRef) in
            if error == nil { onSuccess() }
            else { print(error!); return }
        })
    }
}

