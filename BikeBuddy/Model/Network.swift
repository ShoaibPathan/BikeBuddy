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
    
    var company: List<String>?
    @objc dynamic var href: String = ""
    @objc dynamic var location: Location?
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case company, href, location, name, id
    }
    
    convenience init(company: List<String>, href: String,
                     location: Location?, name: String, id: String) {
        self.init()
        self.company = company
        self.href = href
        self.location = location
        self.name = name
        self.id = id
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let href = try container.decode(String.self, forKey: .href)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(String.self, forKey: .name)
        let location = try container.decode(Location?.self, forKey: .location)
        let companies = try container.decode([String]?.self, forKey: .company)
        let realmCompanies = List<String>()
        if let companies = companies {
            realmCompanies.append(objectsIn: companies)
        }
        self.init(company: realmCompanies, href: href,
                  location: location, name: name, id: id)
    }
}
