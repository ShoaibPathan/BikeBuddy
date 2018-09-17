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
    
    func get(_ completion: @escaping (Result<[Network]>) -> Void) {
        guard let url = URL(string: endpoint) else {
            fatalError()
        }
        
        //var request = URLRequest(url: url)
        
        //        if let params = params  {
        //            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        //        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            guard let data = data, let dataResponse = try? decoder.decode(APIResponse.self, from: data) else {
                completion(.failure(NetworkError.emptyResponse))
                return
            }
            completion(.success(dataResponse.networks))
            }.resume()
    }
}

