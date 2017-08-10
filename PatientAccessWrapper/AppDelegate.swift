//
//  AppDelegate.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 7/24/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Fabric.with([Crashlytics.self])
    ApplicationAssembly.shared.assemble()
    return true
  }
}

