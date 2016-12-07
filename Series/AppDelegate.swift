//
//  AppDelegate.swift
//  Series
//
//  Created by Konstantinos Loutas on 11/12/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        printUserDefaultsData()
        
        return true
    }
    
    func printUserDefaultsData() {
        let defaults = UserDefaults.standard
        let accessToken = defaults.value(forKey: "accessToken") as? String
        let refreshToken = defaults.value(forKey: "refreshToken") as? String
        let username = defaults.object(forKey: "username") as? String
        
        print("Access token: \(accessToken)")
        print("Refresh token: \(refreshToken)")
        print("Username: \(username)")
    }
    
}

