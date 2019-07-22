//
//  AppDelegate.swift
//  Vim
//
//  Created by Jakub Iwaszek on 09/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let navigationAppereace = UINavigationBar.appearance()
        navigationAppereace.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        navigationAppereace.barTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0)
        navigationAppereace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search users", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //uncomment for autologin
        
        /*if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.window!.rootViewController = initialViewController
        } else {
            print("login please")
        }*/
        
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

