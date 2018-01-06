//
//  DiscoverVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DiscoverVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let newPin = MKPointAnnotation()
    fileprivate var locationManager: CLLocationManager!
    fileprivate var locValue: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapPin()
        setupLocationManager()
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnMap))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc fileprivate func longPressOnMap(_ sender: Any) {
        print("long touch on map")
    }
    
    fileprivate func getCityName(){
        // Add below code to get address for touch coordinates.
        //        let geoCoder = CLGeocoder()
        //        let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        //        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        //
        //            // Place details
        //            var placeMark: CLPlacemark!
        //            placeMark = placemarks?[0]
        //
        //            // Address dictionary
        //            print(placeMark.addressDictionary as Any)
        //
        //            // City
        //            if let city = placeMark.addressDictionary!["City"] as? NSString {
        //                print(city)
        //            }
        //        })
    }
    
    fileprivate func setupMapPin(){
        let annotationView = MKPinAnnotationView(annotation: newPin, reuseIdentifier: "pin")
        annotationView.pinTintColor = UIColor(named: "AppAccent")
    }
}


extension DiscoverVC: CLLocationManagerDelegate{
    fileprivate func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
    }
}
