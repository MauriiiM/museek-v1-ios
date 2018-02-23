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
    fileprivate let coordinate = LocationServices.currentCoordinates!//@TODO this line crashes app on first startup sometimes
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        mapView.isRotateEnabled = false
        displayCity(in: mapView)
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnMap))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        // Do any additional setup after loading the view.
//        
//        print("\n\nCITY IS\n\n")
//        LocationServices.current(){ city in  print("\(city)\n\n") }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func displayCity(in map: MKMapView){
        let locationPin = MKPointAnnotation()
        let annotationView = MKPinAnnotationView(annotation: locationPin, reuseIdentifier: "pin")
        annotationView.pinTintColor = UIColor(named: "AppAccent")
        annotationView.animatesDrop = true
        
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        locationPin.coordinate = LocationServices.currentCoordinates!
        map.setRegion(region, animated: true)
//        map.addAnnotation(locationPin)
    }
    
    @objc fileprivate func longPressOnMap(_ sender: Any) {
        print("long touch on map")
    }
}
