//
//  MapViewController.swift
//  MovieApp
//
//  Created by son on 2017. 5. 29..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            centerMapOnLocation(location: locationManager.location!, map: mapView, radius: regionRadius)
        } else {
            locationManager.requestAlwaysAuthorization() //requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation, map: MKMapView, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  radius * 2.0, radius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mapView.delegate = self
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            //locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("location enabled")
            checkLocationAuthorizationStatus()
        }
        else
        {
            print("Location service disabled");
        }
        
        
        // Do any additional setup after loading the view.
    }
}
