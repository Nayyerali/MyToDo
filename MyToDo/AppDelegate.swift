//
//  AppDelegate.swift
//  MyToDo
//
//  Created by Nayyer Ali on 12/10/19.
//  Copyright © 2019 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        checkIfUserLoggedin()
        return true
    }
    
    func checkIfUserLoggedin(){
        
        if let user = Auth.auth().currentUser{
            // User is already Loggedin
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialNavigation = storyboard.instantiateViewController(withIdentifier: "initialNavigationOfLoginPage") as! UINavigationController
            
            let homeTabbar = storyboard.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
            initialNavigation.setNavigationBarHidden(true, animated: false)
            initialNavigation.pushViewController(homeTabbar, animated: false)
            
            self.window?.rootViewController = initialNavigation
             
        }else{
            // User is not loggedin
            print("not logged in")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

