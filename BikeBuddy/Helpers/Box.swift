//
//  Box.swift
//  BikeBuddy
//
//  Created by Lech H. Conde on 18/05/2018.
//  Copyright © 2018 Lech H. Conde. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> Void
    typealias ErrorListener = (Error) -> Void
    
    var value: T? {
        didSet {
            listener?(value!)
            runErrorClosures()
            runResultClosures()
        }
    }
    
    var error: Error? {
        didSet {
            runResultClosures()
            runErrorClosures()
        }
    }
    
    private var listener: Listener?
    private var errorClosures = [ErrorListener]()
    private var resultClosures = [Listener]()
    
    init(_ value: T) {
        self.value = value
    }
    
    init() { }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value!)
    }
    
    func resolve(_ value: T) {
        self.value = value
    }
    
    func fail(_ error: Error) {
        self.error = error
    }
    
    @discardableResult
    func then(_ result: @escaping Listener) -> Box<T> {
        resultClosures.append(result)
        return self
    }
    
    @discardableResult
    func error(_ error: @escaping ErrorListener) -> Box<T> {
        errorClosures.append(error)
        return self
    }
}

private extension Box {
    func runResultClosures() {
        resultClosures.forEach { value.map($0) }
    }
    
    func runErrorClosures() {
        errorClosures.forEach { error.map($0) }
    }
}
