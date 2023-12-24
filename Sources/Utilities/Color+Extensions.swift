//
//  File.swift
//  
//
//  Created by Hardik Modha on 23/12/23.
//

import UIKit

public extension UIColor {
    convenience init?(hex: String) {
        var formattedString = hex.trimmed
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        guard formattedString.count == 6 else {
            return nil
        }
        
        var rgb: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgb)
        
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
