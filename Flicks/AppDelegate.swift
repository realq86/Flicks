//
//  AppDelegate.swift
//  Flicks
//
//  Created by Developer on 10/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let tabBarController = UITabBarController()
        
        
        if let nowPlayingNaviVC = storyboard.instantiateViewController(withIdentifier: "MovieNavigationController") as? UINavigationController,
            let topRatedNaviVC = storyboard.instantiateViewController(withIdentifier: "MovieNavigationController") as? UINavigationController {
            
            if let movieVC = nowPlayingNaviVC.topViewController as? MoviesViewController {
                movieVC.playNowOrTopRated = "PLAYNOW"
                nowPlayingNaviVC.tabBarItem.title = "NOW PLAYING"
                nowPlayingNaviVC.tabBarItem.image = UIImage(named: "Camera")
            }
            if let topRatedVC = topRatedNaviVC.topViewController as? MoviesViewController {
                topRatedVC.playNowOrTopRated = "TOPRATED"
                topRatedNaviVC.tabBarItem.title = "TOP RATED"
                topRatedNaviVC.tabBarItem.image = UIImage(named: "Star")
            }

            tabBarController.viewControllers = [nowPlayingNaviVC, topRatedNaviVC]
            UITabBar.appearance().tintColor = UIColor.gray
//            tabBarController.tabBar.barTintColor = 
        }
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
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

