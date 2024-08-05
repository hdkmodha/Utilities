//
//  Storage.swift
//
//
//  Created by Hardik Modha on 28/11/23.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct Storage<T> {
    
    @ObservedObject private var internalStorage: InternalStorage
    
    public init(_ key: String, defaultValue: T) {
        self.internalStorage = InternalStorage(key: key, defaultValue: defaultValue)
    }
    
    public var wrappedValue: T {
        get {
            self.internalStorage.getValue()
        }
        nonmutating set {
            self.internalStorage.setValue(newValue)
        }
    }
    
    class InternalStorage: ObservableObject {
        let key: String
        let defaultValue: T
        private var isChanged: Bool = false
        
        init(key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        func getValue() -> T {
            _ = isChanged
            return UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        }
        
        func setValue(_ newValue: T) {
            UserDefaults.standard.setValue(newValue, forKey: key)
            self.isChanged.toggle()
        }
    }
}

