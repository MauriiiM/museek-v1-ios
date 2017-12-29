//
//  MapSignUp.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/27/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationSignUp: UIViewController {
    fileprivate var _user: User!
    var user: User! {
        get{ return _user }
        set{ _user = newValue }
    }
    fileprivate let locManager = CLLocationManager()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let signUp = segue.destination as! SignUpVC
        signUp.user = _user
    }
    
    @IBAction fileprivate func allowingLocationAccess(_ sender: RoundedButton) {
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locManager.requestWhenInUseAuthorization()
        }
    }
    
    /**
     checks if user has previously authorized app to use location
     */
    //    private func checkLibraryAuthorization(_ completionHandler: @escaping ((_ status: CLAuthorizationStatus) -> Void)) {
    //        switch CLLocationManager.authorizationStatus() {
    //        case .authorized:
    //            //The user has previously granted access to the camera.
    //            completionHandler(.authorized)
    //        case .notDetermined:
    //            // The user has not yet been presented with the option to grant video access so request access.
    //            CLLocationManager.requestAlwaysAuthorization(        case .denied:
    //            // The user has previously denied access.
    //            completionHandler(.denied)
    //        case .restricted:
    //            // The user doesn't have the authority to request access e.g. parental restriction.
    //            completionHandler(.restricted)
    //        case .authorizedAlways:
    //            <#code#>
    //        case .authorizedWhenInUse:
    //            <#code#>
    //        }
    //    }
}
