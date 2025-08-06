//
//  FruitDetailsView.swift
//  FruitWalk
//
//  Created by Claire S on 2/20/25.
//

import SwiftUI
import MapKit

let dateFormatter = DateFormatter()
let WalkDistance =  0...8000.0
let BikeDistance =  8000.0...32000.0
let DriveDistance = 32000.0...

/// FruitDetailsView consists of two views, a TitleView and FruitDetails
struct FruitDetailsView<TitleView: View>: View {
    let location: FruitLocation
    let startCoordinate: CLLocationCoordinate2D?
    @ViewBuilder let titleView: TitleView
    
    init(
        location: FruitLocation,
        titleView: TitleView,
        startCoordinate: CLLocationCoordinate2D?
    ) {
        self.location = location
        self.titleView = titleView
        self.startCoordinate = startCoordinate
    }
    
    var body: some View {
        VStack {
            titleView
            FruitDetails(location: location, startCoordinate: startCoordinate)
        }
    }
}
  
struct FruitDetails: View {
    let location: FruitLocation
    let startCoordinate: CLLocationCoordinate2D?
    @Environment(LocationManager.self) var locationManager
    @Environment(MapStore.self) private var mapStore
    @State var details: LocationDetails?
    @State var distanceMeters: Double?
    @State var requestedDetails = false
    @State var requestedRoute = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let urlString = location.photo, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        Image("multifruit_icon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Image(location.defaultImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
                VStack(alignment: .leading){
                    DirectionsButton(location: location)
                    Spacer().frame(height: 8)
                    if let address = details?.address, let firstComma = address.firstIndex(of: ",") {
                        let street = address[..<firstComma]
                        Text(street)
                            .lineLimit(2)
                            .bold()
                            .italic()
                    } else {
                        Text("street address not provided")
                            .foregroundStyle(.gray)
                    }
                    Spacer().frame(height: 4)
                    DistanceView(fruitLocation: location, includeDirections: false, startCoordinate: startCoordinate)
                        .padding(0)
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            } // HStack
            HStack {
                Image(systemName: "hand.palm.facing")
                if let access = details?.access {
                    Text(access.description())
                        .italic()
                } else {
                    Text("Access unknown")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            let author = details?.author ?? "unknown"
            HStack {
                Image(systemName: "person")
                Text("Created by: ")
                Text(author)
                    .bold()
                Spacer()
            }
            .font(.caption)
            let date = Date.getISODate(string: details?.createdDate)
            HStack {
                Image(systemName: "pencil")
                Text("Added: ")
                if let date = date {
                    Text(date, style: .date)
                } else {
                    Text("unknown")
                }
                Spacer()
            }
            .font(.caption)
            if let details = details {
                Text(details.fruitingDisplayString)
                    .font(.caption)
                    .bold()
                    .italic()
            }
            if let description = details?.description {
                VStack(alignment: .leading) {
                    Text(description)
                }
                .padding(16.0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("green_background"))
            }
            Spacer()
        } // VStack
        .padding(EdgeInsets(top: 8, leading: 16.0, bottom: 0, trailing: 16.0))
        .task {
            if !requestedDetails && details == nil {
                requestedDetails = true
                let response = await mapStore.getFruitLocationDetails(for: location.identifier)
                if let responseData = response.details {
                    details = responseData
                } else {
                    // not neccessary to show the error to the user
                    print(response.error ?? "error fetching details")
                }
                requestedDetails = false
            }
        }
    }

}

