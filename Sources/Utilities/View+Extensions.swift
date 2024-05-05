//
//  View+Extensions.swift
//
//
//  Created by Hardik Modha on 05/05/24.
//

import Foundation
import UIKit

public extension UIView {
    
    //MARK: - Apply CornerRadius
    func applyCornerRadius(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
