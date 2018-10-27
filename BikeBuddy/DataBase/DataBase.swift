//
//  DataBase.swift
//  BikeBuddy
//
//  Created by Naveen Magatala on 9/17/18.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import RealmSwift
import MapKit

struct DataBase { private init() { } }

// MARK: Write
extension DataBase {
    static func write(_ objects: Object...) {
        let realm = try! Realm()
        objects.forEach { object in
            try! realm.write {
                realm.add(object, update: true)
            }
        }
    }
    
    static func write(_ objects: [Object]) {
        let realm = try! Realm()
        objects.forEach { object in
            try! realm.write {
                realm.add(object, update: true)
            }
        }
    }
    
    static func create(_ type: Object.Type, _ object: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(type, value: object, update: true)
        }
    }
}

// MARK: Read
extension DataBase {
    static var isDataInValid: Bool {
        // TODO: Need better refresh strategy to fetch data on regular basis
        
        let realm = try! Realm()
        return realm.objects(Network.self).isEmpty
    }
    
    static func nearbySpots(mapRect: MKMapRect) -> [Network] {
        let realm = try! Realm()
        let data = realm.objects(Network.self).filter {
            mapRect.contains(MKMapPoint($0.coordinates))
        }
        return Array(data)
    }
}
