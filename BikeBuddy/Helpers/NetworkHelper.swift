//
//  NetworkHelper.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case emptyResponse
}

protocol Gettable {
    associatedtype DataType
    func get() -> Box<DataType>
}
