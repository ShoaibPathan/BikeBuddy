//
//  BikeBuddyServiceHandler.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

protocol BikeBuddyServiceHandler {
    func didReceiveData(_ data: [Network])
    func didFailWith(_ error: Error)
}

extension BikeBuddyServiceHandler {
    public func getBikeBuddyData<T: Gettable> (from service: T) where T.DataType == [Network] {
        service.get() {result in
            switch result {
            case .success(let bikeBuddyData):
                self.didReceiveData(bikeBuddyData)
            case .failure(let error):
                self.didFailWith(error)
            }
        }
    }
}
