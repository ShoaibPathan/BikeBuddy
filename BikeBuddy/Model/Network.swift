//
//  Network.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    var networks: [Network]
}

struct Network: Codable {
    var company: [String]?
    var href: String?
    var location: Location?
    var name: String?
    var id: String?
//    var stations: [Station]?
}
