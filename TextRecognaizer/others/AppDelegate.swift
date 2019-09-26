//
//  AppDelegate.swift
//  TextRecognaizer
//
//  Created by Andrei Konoplev on 16/09/2019.
//  Copyright © 2019 Коноплев Андрей. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Override point for customization after application launch.
        return true
    }
}

