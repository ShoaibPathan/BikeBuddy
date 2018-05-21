//
//  MainViewModel.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation
import MapKit

class MainViewModel {
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1500
    
    private var bikeBuddyService = BikeBuddyService()
    var bikeBuddyData: Box<[Network]?> = Box(nil)
    var curretLocation: Box<Location?> = Box(nil)
    
    var mapStationLocations: Box<[MapStationLocation]?> = Box(nil)
    
    var fooBikeBuddyStations: [Station] = [
        Station(name: "pos 1", timestamp: "123456789", location: Location(latitude: 42.487333, longitude: -83.263931), freeBikes: 10, emptySlots: 8, id: "123456789"),
        Station(name: "pos 2", timestamp: "123456789", location: Location(latitude: 42.480135, longitude: -83.232492), freeBikes: 0, emptySlots: 8, id: "123456789"),
        Station(name: "pos 3", timestamp: "123456789", location: Location(latitude: 42.473734, longitude: -83.258310), freeBikes: 4, emptySlots: 0, id: "123456789"),
        Station(name: "pos 4", timestamp: "123456789", location: Location(latitude: 42.480210, longitude: -83.287035), freeBikes: 6, emptySlots: 8, id: "123456789")
    ]
    
    func fetchFooData() {
        var mapStationLocations = [MapStationLocation]()
        for (i, fooStation) in fooBikeBuddyStations.enumerated() {
            let mapStationLocation = MapStationLocation(with: fooStation, and: "Foo Station \(i)")
            mapStationLocations.append(mapStationLocation)
        }
        self.mapStationLocations.value = mapStationLocations
    }
    
    func fetchData() {
        getBikeBuddyData(from: bikeBuddyService)
    }
    
    func fetchData(for location: Location, distance: Int = 0) {
        bikeBuddyService.update(location: location, distance: distance)
        getBikeBuddyData(from: bikeBuddyService)
    }
    
    var networkList: [Network]? {
        return bikeBuddyData.value
    }
}

extension MainViewModel: BikeBuddyServiceHandler {
    func didReceiveData(_ data: Array<Network>) {
        bikeBuddyData.value = data
    }
    
    func didFailWith(_ error: Error) {
        var localizedDescription = error.localizedDescription
        if let error = error as? NetworkError, case .emptyResponse = error {
            localizedDescription = "Empty response"
        }
        print("Network Error: \(localizedDescription)")
    }
}



