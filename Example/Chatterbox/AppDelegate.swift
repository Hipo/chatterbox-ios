//
//  AppDelegate.swift
//  Chatterbox
//
//  Created by Hakan Demiröz on 09/21/2017.
//  Copyright (c) 2017 Hakan Demiröz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = ViewController()
        return true
    }
    
    
}

