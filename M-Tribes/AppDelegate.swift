//
//  AppDelegate.swift
//  M-Tribes
//
//  Created by Atalyk Akash on 1/23/18.
//  Copyright © 2018 Atalyk Akash. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let mapViewNavigationController = UINavigationController(rootViewController: MapViewController())
        
        window?.rootViewController = mapViewNavigationController
        
        GMSServices.provideAPIKey(Utils.googleMapsApiKey)
        
        return true
    }
}

