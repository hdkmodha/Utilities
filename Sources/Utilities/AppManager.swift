//
//  AppManager.swift
//
//
//  Created by Hardik Modha on 07/02/24.
//

import UIKit

public final class AppManager: NSObject {
    
    public static let shared = AppManager()
    
    private override init() {
        
    }
    
    private var windowScene: UIWindowScene? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene
        }
        return nil
    }
    
    private var window: UIWindow? {
        guard let windowScene = self.windowScene else { return nil }
        if #available(iOS 15.0, *) {
            return windowScene.keyWindow
        } else {
            return windowScene.windows.first
        }
    }
    
    private var rootViewController : UIViewController {
        guard let window = self.window, let rootVC = window.rootViewController else { return  UIViewController() }
        return rootVC
    }
    
    ////
    ///  to get top most view controller in app
    public func topViewController() -> UIViewController {
        return self.rootViewController.getTopViewController()
    }
    
    public func setRootVC(withViewController controller: UIViewController) {
        guard let window = self.window else { return }
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
