//
//  AppDelegate.swift
//  NapTime
//
//  Created by Eric Andersen on 8/28/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print("Error requesting user notifications \(error) \(error.localizedDescription)")
            }
            if !granted {
                print("Notification Access has been denied.")
            }
        }
        return true
    }
}

