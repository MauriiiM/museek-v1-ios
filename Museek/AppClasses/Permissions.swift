//
//  Permissions.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/16/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import Photos


class Permissions{
    /**
     checks if user has previously authorized app to use camera
     */
    static func checkLibraryAuthorization(_ completionHandler: @escaping ((_ status: PHAuthorizationStatus) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(.authorized)
        case .notDetermined:
            // The user has not yet been presented with the option to grant camera access so request access.
            PHPhotoLibrary.requestAuthorization({ permission in
                completionHandler(permission)
            })
        case .denied:
            // The user has previously denied access.
            completionHandler(.denied)
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(.restricted)
        }
    }
}
