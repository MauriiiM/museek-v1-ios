//
//  AppDelegate.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/1/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    static var top: UIViewController? {
        get { return topViewController()}
    }
    static var root: UIViewController? {
        get { return UIApplication.shared.delegate?.window??.rootViewController }
    }
    /**
     recursively calls deeper into vc stack to get top most view
     from: " https://stackoverflow.com/questions/41073915/how-to-get-the-current-displaying-uiviewcontroller-not-in-appdelegate/41074725#41074725 "
     */
    static func topViewController(from viewController: UIViewController? = root) -> UIViewController? {
        if let tabBarViewController = viewController as? UITabBarController {
            return topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
    
    /**
     "hack overwriting" method to force camera to be in landscape mode
     */
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let vcShouldBeLandscape = CameraVC.isPresented || CameraVC.isPresented
    
        return vcShouldBeLandscape ? .landscape : .portrait
    }
    
    //@TODO Product > Scheme > Edit Scheme... [Diagnostics/Zombie mode off]
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

