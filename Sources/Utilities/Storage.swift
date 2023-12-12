//
//  Storage.swift
//
//
//  Created by Hardik Modha on 28/11/23.
//

import Foundation

@propertyWrapper 
public struct Storage<T> {
    
    let key: String
    let defaultValue: T
    private let container: UserDefaults = .standard
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

