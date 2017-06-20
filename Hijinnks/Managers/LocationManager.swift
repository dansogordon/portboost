//
//  LocationManager.swift
//  Hijinnks
//
//  Created by adeiji on 2/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    
    func startStandardUpdates () {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the current location and than stop updating the location because we won't need it running constantly
        var currentMostRecentLocation:CLLocation!
        
        for location in locations {
            if currentMostRecentLocation != nil {
                if location.timestamp < currentMostRecentLocation.timestamp {
                    currentMostRecentLocation = location
                }
            }
            else {
                currentMostRecentLocation = location
            }
        }
        
        currentLocation = currentMostRecentLocation
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not get the current location")
    }
    
}
