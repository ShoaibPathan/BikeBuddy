//
//  MapStationLocation.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation
import MapKit

class MapStationLocation: NSObject, MKAnnotation {
    var station: Station?
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String? {
        guard let station = self.station else { return nil }
        return "Bikes : \(station.freeBikes) - Slots : \(station.emptySlots)"
    }
    
    init(with station: Station, and title: String? = nil) {
        self.station = station
        self.title = title
        coordinate = CLLocationCoordinate2D(latitude: station.location.latitude, longitude: station.location.longitude)
    }
}
