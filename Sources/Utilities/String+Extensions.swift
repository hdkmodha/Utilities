//
//  String+Extensions.swift
//
//
//  Created by Hardik Modha on 28/11/23.
//

import UIKit

public extension String {
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    var lenght: Int {
        return self.count
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    var toFloat: Float? {
        return Float(self)
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = #"^\+(?:[0-9] ?){6,14}[0-9]$"#
        let testPhone = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return testPhone.evaluate(with: self)
    }
    
    var isValidURL: Bool {
        if let url = self.toURL {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    var fileExtensions: String {
        if let url = self.toURL {
            return url.pathExtension
        }
        return ""
    }
    
    
}
