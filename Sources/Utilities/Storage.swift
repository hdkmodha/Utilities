//
//  Storage.swift
//
//
//  Created by Hardik Modha on 28/11/23.
//

import Foundation

@propertyWrapper 
public struct Storage<Value> {
    
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

