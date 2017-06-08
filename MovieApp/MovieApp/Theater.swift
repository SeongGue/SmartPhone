//
//  Theater.swift
//  MovieApp
//
//  Created by son on 2017. 6. 5..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import Foundation

import MapKit

import AddressBook

class Theater: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String?{
        return locationName
    }
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    func mapItem() -> MKMapItem{
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
