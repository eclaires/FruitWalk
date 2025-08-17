//
//  DistanceLabel.swift
//  FruitWalk
//
//  Created by Claire S on 3/26/25.
//

import SwiftUI
import MapKit

// If start is nil, uses the user location
struct DistanceLabel: View {
    let start: CLLocationCoordinate2D?
    let end: CLLocationCoordinate2D
    @Environment(LocationManager.self) var locationManager
    @State var distanceMeters: Double?
    @State var requestedDetails = false
    @State var requestedRoute = false
    
    var body: some View {
        Label(getDistanceString(distanceMeters),
              systemImage: getIconString(distanceMeters))
            .font(.caption)
            .labelStyle(.titleAndIcon)
            .onAppear() {
                setDistance()
            }
            .onChange(of: locationManager.userLocation) { oldValue, newValue in
                setDistance()
            }
    }
    
    func getDistanceString(_ meters: Double?) -> String {
        if let m = meters {
            return m.formattedDistance()
        } else {
            return ""
        }
    }
    
    func getIconString(_ meters: Double?) -> String {
        var imageString: String = "car.side"
        if let meters = distanceMeters {
            if WalkDistance.contains(meters) {
                imageString = "figure.walk"
            } else if BikeDistance.contains(meters) {
                imageString = "bicycle"
            }
        }
        return imageString
    }
    
    func setDistance() {
        if  let startCoordinate = start ?? locationManager.userLocation?.coordinate {
            if !requestedRoute && distanceMeters == nil {
                requestedRoute = true
                Task {
                    distanceMeters = await end.walkingDistance(from: startCoordinate)
                    requestedRoute = false
                }
            }
        }
    }
}

