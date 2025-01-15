//
//  AppDelegate.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import UIKit
import GooglePlacesSwift

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PlacesClient.provideAPIKey("AIzaSyB5lgOiQBS7qsuAV0-Ejusvm98dN7xe6co")
        
        return true
    }

    // Implement other app lifecycle methods as needed
}
