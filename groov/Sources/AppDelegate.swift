//
//  AppDelegate.swift
//  groov
//
//  Created by PilGwonKim_MBPR on 2016. 7. 6..
//  Copyright © 2016년 PilGwonKim. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                migration.enumerateObjects(ofType: Video.className()) { _, newObject in
                    if oldSchemaVersion < 1 {
                        newObject!["duration"] = ""
                    }
                }
        })
        
        let env = ProcessInfo.processInfo.environment
        if let uiTests = env["XCUITEST"], uiTests == "1" {
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        #if !DEBUG
        Thread.sleep(forTimeInterval: 2.0)
        #endif
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc: PlaylistListViewController = PlaylistListViewController()
        let nav: UINavigationController = UINavigationController(rootViewController: vc)

        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
