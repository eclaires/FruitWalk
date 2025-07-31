//
//  LookAroundData.swift
//  FruitWalk
//
//  Created by Claire S on 3/14/25.
//

import Foundation
import MapKit

/// ViewModel which contains a MKLookAroundScene for coordinates set in getScene()
@MainActor @Observable class LookAroundData {
    var errorMessage: String?
    var scene: MKLookAroundScene?
    @ObservationIgnored private(set) var coordinate: CLLocationCoordinate2D?
    
    func clearData() {
        scene = nil
        coordinate = nil
        errorMessage = nil
    }
    
    /// function which asyncronously gets the MKLookAroundScene for the coordinate passed
    /// the LookAroundData will be updated with either a new scene or a failed state
    /// - Parameter coordinate: the coordinate for the scene
    func getScene(from coordinate: CLLocationCoordinate2D?) async {
        scene = nil
        self.coordinate = coordinate
        await loadScene()
    }
    
    private func loadScene() async {
        Task {
            if let coordinate = self.coordinate {
                let request = MKLookAroundSceneRequest(coordinate: coordinate)
                do {
                    let scene = try await request.scene
                    if self.coordinate == coordinate {
                        if scene == nil {
                            // TODO: localized and better mesaging, use an Error object
                            self.errorMessage = "Unable to look around at this map location"
                        } else {
                            self.scene = scene
                        }
                    }
                } catch (let error) {
                    print(error)
                    // TODO: localized and better mesaging, use an Error object
                    self.errorMessage = "Unable to look around at this map location"
                }
            }
        }
    }
    
}
