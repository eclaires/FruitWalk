//
//  LocationManager.swift
//  FruitWalk
//
//  Created by Claire S on 2/18/25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable class LocationManager: NSObject, CLLocationManagerDelegate {
  @ObservationIgnored let manager = CLLocationManager()
    private(set) var userLocation: CLLocation?
    private(set) var isAuthorized = false
    private(set) var isRequestingLocation = false
    private(set) var isContinuouslyUpdating = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 160 // 1/10th of a mile
        manager.startUpdatingLocation()
        isContinuouslyUpdating = true
    }
    
    func startContinuousUpdates()  {
        manager.startUpdatingLocation()
        isContinuouslyUpdating = true
    }
    
    func stopContinuousUpdates()  {
        manager.stopUpdatingLocation()
        isContinuouslyUpdating = false
    }
    
    // requestLocation doesn't do anything if startContinuousUpdates is active
    func requestLocation(resetCurrent: Bool = false) {
        if !isRequestingLocation {
            if resetCurrent {
                userLocation = nil
            }
            manager.requestLocation()
            isRequestingLocation = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager did UPDATE Locations THREAD: " + String(cString: __dispatch_queue_get_label(nil)))
        userLocation = locations.last
        isRequestingLocation = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        isRequestingLocation = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("access denied")
        default:
            isAuthorized = true
        }
    }
}
