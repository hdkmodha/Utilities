//
//  File.swift
//  
//
//  Created by Hardik Modha on 23/12/23.
//

import Foundation
import UIKit

public extension Int {
    
    var absoluteValue: Int {
        return abs(self)
    }
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    func multiple(ofValue value: Int) -> Bool {
        return self.isMultiple(of: value)
    }
    
    func distance(toValue value: Int) -> Int {
        return self.distance(to: value)
    }
    
    var toDouble: Double {
        return Double(self)
    }
    
    var toString: String {
        return "\(self)"
    }
}

