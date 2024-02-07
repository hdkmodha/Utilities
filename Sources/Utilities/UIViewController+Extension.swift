//
//  File.swift
//  
//
//  Created by Hardik Modha on 07/02/24.
//

import UIKit

extension UIViewController {
    
    func getTopViewController() -> UIViewController {
        
        if let tabbarVC = self as? UITabBarController, let selectedVC = tabbarVC.selectedViewController {
            return selectedVC.getTopViewController()
        }
        
        if let navVC = self as? UINavigationController, let visibleVC = navVC.visibleViewController {
            return visibleVC.getTopViewController()
        }
        
        if let presentedViewController = presentedViewController {
            return presentedViewController.getTopViewController()
        }
        
        return self
        
    }
}

