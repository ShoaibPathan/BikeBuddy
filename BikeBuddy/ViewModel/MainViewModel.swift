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
    
    let isdataReceived = Box<Bool>()
    
    var currentLocation: CLLocation {
        return locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    let regionRadius: CLLocationDistance = 1500
    
    private lazy var bikeBuddyService = BikeBuddyService()
    
    func fetchData() {
        if DataBase.isDataInValid {
            getBikeBuddyData(from: bikeBuddyService)
        }
    }
    
    func setLocationManagerDelegate(_ delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
    }
}

extension MainViewModel: BikeBuddyServiceHandler {
    func didReceiveData(_ data: [Network]) {
        DataBase.write(data)
        isdataReceived.resolve(true)
    }
    
    func didFailWith(_ error: Error) {
        var localizedDescription = error.localizedDescription
        if let error = error as? NetworkError, case .emptyResponse = error {
            localizedDescription = "Empty response"
        }
        print("Network Error: \(localizedDescription)")
    }
}
