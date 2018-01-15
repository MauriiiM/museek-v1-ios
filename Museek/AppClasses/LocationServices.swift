//
//  LocationServices.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/13/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import CoreLocation
import UIKit

class LocationServices:  NSObject, CLLocationManagerDelegate{
    fileprivate static var _locationManager: CLLocationManager? //to transfer data between one or more device inputs
    static var locationManager: CLLocationManager { //singleton pattern
        get{
            if _locationManager != nil { return _locationManager! }
            else {
                _locationManager = CLLocationManager()
                _locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    _locationManager?.requestAlwaysAuthorization()
                }
                _locationManager?.startUpdatingLocation()
                
                return _locationManager!
            }
        }
    }
    static var currentLocation = LocationServices.locationManager.location
    static var currentCoordinates = LocationServices.locationManager.location?.coordinate
    
//    static func current(cityName: @escaping (String) -> Void) {
//        // Add below code to get address for touch coordinates.
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(currentLocation!){
//            (placemarks, error) -> Void in
//
//            if let placemarks = placemarks{
//                if let city = placemarks.first?.locality {
//                    cityName(city)
//                }
//            }
//        }
//        geoCoder.geocodeAddressString("Albuquerque, NM"){
//            (something, error) in
//            if error == nil {
//                print("\n\nIDK WHAT TO EXPECT\(something!)\n\n")
//            } else { print("\n\nERRROOORRR\(something!)\n\n") }
//        }
//    }
}
