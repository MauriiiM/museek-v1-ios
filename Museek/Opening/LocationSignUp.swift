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
}
