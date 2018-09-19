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
}
