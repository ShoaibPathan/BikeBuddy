//
//  BikeBuddyService.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

struct BikeBuddyService: Gettable {
    
    let endpoint = "http://api.citybik.es/v2/networks/"
    var params: [String: Any]?
    
    mutating func update(location: Location, distance: Int) {
        params = ["latitude": location.latitude, "longitude": location.longitude, "distance": distance]
    }
    
    func get() -> Box<[Network]> {
        guard let url = URL(string: endpoint) else {
            fatalError()
        }
        
        let box = Box<[Network]>()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return box.fail(error)
            }
            
            let decoder = JSONDecoder()
            var dataResponse: APIResponse
            do {
                guard let data = data else { return }
                dataResponse = try decoder.decode(APIResponse.self, from: data)
                return box.resolve(dataResponse.networks)
            } catch {
                box.fail(error)
            }
            }.resume()
        return box
    }
}
