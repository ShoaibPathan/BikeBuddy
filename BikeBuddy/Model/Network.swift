//
//  Network.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import RealmSwift
import Foundation

struct APIResponse: Decodable {
    var networks: [Network]
}

class Network: Object, Decodable {
    
    @objc dynamic var location: Location?
    @objc dynamic var name: String = ""
    
    @objc dynamic var uniqueKey: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case location, name
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let location = try container.decode(Location?.self, forKey: .location)
        let uniqueKey = "\(name)\(location?.latitude ?? 0)"
        self.init(location: location, name: name, uniqueKey: uniqueKey)
    }
    
    override class func primaryKey() -> String? {
        return "uniqueKey"
    }
}

// Initializers
extension Network {
    convenience init(location: Location?, name: String, uniqueKey: String) {
        self.init()
        self.location = location
        self.name = name
        self.uniqueKey = uniqueKey
    }
}
