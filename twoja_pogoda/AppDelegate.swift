//
//  AppDelegate.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 22.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import UIKit
import YourWeatherFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        tab bar offset
//        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -(49 / 2 - 10))
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor(red: 91/255, green: 154/255, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont(name: "Menlo", size: 15)!], for: UIControlState.normal) // tab bar text
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: UIControlState.selected) // selected tab bar text
//        UITabBar.appearance().tintColor = UIColor(red: 12/255, green: 25/255, blue: 45/255, alpha: 1)
        
//        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 15)!]
        //po zaladowaniu otwiera sie karta "teraz"
        if self.window!.rootViewController as? UITabBarController != nil {
            let tabBarController = self.window!.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 1
        }
        //wczytywanie zapisanych kolorow/ustawianie domyslnych jesli ich nie ma
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "savedColors") == nil {
//            yeah its deprecated, fuck off
            let savedDefaults = NSKeyedArchiver.archivedData(withRootObject: SavedColors.defaultSettings)
            defaults.set(savedDefaults, forKey: "savedColors")
            savedColors = SavedColors.defaultSettings
        } else {
            let colorData = defaults.object(forKey: "savedColors") as! Data
            savedColors = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? SavedColors
        }
        //wczytywanie ustawionej jednostki temperatury/ustawianie domyslne na C
        if defaults.object(forKey: "temp") == nil {
            let temp: TempUnit = .c
            defaults.set(temp.rawValue, forKey: "temp")
            tempUnit = temp
        } else {
            let tempRaw = defaults.object(forKey: "temp") as! String
            tempUnit = TempUnit(rawValue: tempRaw)
        }
        let stack = CoreDataStack()
        stack.preloadDbData()
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

