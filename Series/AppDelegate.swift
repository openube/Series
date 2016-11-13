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
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        if let userAccessToken = defaults.object(forKey: "accessToken") {
            print("User access token: \(userAccessToken)")
        }
        return true
    }
    
}

