//
//  Location.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object, Decodable {
    @objc dynamic var city: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    @objc dynamic var uniqueKey: String = ""
    
    enum CodingKeys: String, CodingKey {
        case city, country, latitude, longitude
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let city = try container.decode(String.self, forKey: .city)
        let country = try container.decode(String.self, forKey: .country)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let uniqueKey = "\(latitude)\(longitude)"
        self.init(city: city, country: country, latitude: latitude,
                  longitude: longitude, uniqueKey: uniqueKey)
    }
    
    override class func primaryKey() -> String? {
        return "uniqueKey"
    }
}

// Initializers
extension Location {
    convenience init(city: String, country: String, latitude: Double,
                     longitude: Double, uniqueKey: String) {
        self.init()
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.uniqueKey = uniqueKey
    }
}
