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
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    lazy var currentLocation: CLLocation = {
        return locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }()
    
    let regionRadius: CLLocationDistance = 1500
    
    private var bikeBuddyService = BikeBuddyService()
    var bikeBuddyData: Box<[Network]> = Box([])
    var curretLocation: Box<Location?> = Box(nil)
    
    var mapStationLocations: Box<[MapStationLocation]?> = Box(nil)
    
    func fetchData() {
        if DataBase.isDataInValid {
            getBikeBuddyData(from: bikeBuddyService)
        }
    }
    
    func fetchData(for location: Location, distance: Int = 0) {
        bikeBuddyService.update(location: location, distance: distance)
        getBikeBuddyData(from: bikeBuddyService)
    }
    
    var networkList: [Network]? {
        return bikeBuddyData.value
    }
    
    func setLocationManagerDelegate(_ delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
    }
}

extension MainViewModel: BikeBuddyServiceHandler {
    func didReceiveData(_ data: [Network]) {
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



