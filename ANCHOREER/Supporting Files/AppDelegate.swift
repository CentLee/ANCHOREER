//
//  AppDelegate.swift
//  ANCHOREER
//
//  Created by SatGatLee on 2021/08/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    let mainVC = MovieSearchViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else { return false }
    window.rootViewController = UINavigationController(rootViewController: mainVC)
    window.makeKeyAndVisible()
    return true
  }

}

