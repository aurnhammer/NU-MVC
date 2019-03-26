//
//  AppDelegate.swift
//  Aurnhammer
//
//  Created by William Aurnhammer on 1/25/19.
//  Copyright © 2019 Aurnhammer. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: AlbumsViewController())
        setupAppearance()
        return true
    }
    
    private func setupAppearance() {
        
        // Colors
        window?.backgroundColor = UIColor(named: "BackgroundColor")
        window?.tintColor = UIColor(named: "TintColor")
        // Fonts
        if let font = UIFont(name: "Industry-Demi", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font]
        }
        if let font = UIFont(name: "Industry-Black", size: 40) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: font]
        }
        if let font = UIFont(name: "Industry-Demi", size: 15) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            UILabel.appearance(whenContainedInInstancesOf:[UIButton.self]).font = font
            UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self]).setTitleTextAttributes([NSAttributedString.Key.font: font], for: .highlighted)
            UILabel.appearance(whenContainedInInstancesOf:[UIButton.self]).font = font
        }
    }
    
}
