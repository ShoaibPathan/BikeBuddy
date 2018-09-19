//
//  Station.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

struct Station {
    var name: String
    var timestamp: String
    var location: Location
    var freeBikes: Int
    var emptySlots: Int
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case location
        case freeBikes = "free_bikes"
        case emptySlots = "empty_slots"
        case id
    }
}
