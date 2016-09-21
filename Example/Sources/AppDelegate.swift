//
//  AppDelegate.swift
//  Glover iOS Example
//
//  Created by Sebastian Owodzin on 24/04/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import UIKit
import CoreData
import Glover

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var manager: Manager!

    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Remove old db files
        do {
            try FileManager().removeItem(atPath: applicationDocumentsDirectory.appendingPathComponent("db.sqlite").path)
        } catch {
            
        }

        // Init Glover
        let model = NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "Model", withExtension: "momd")!)!
        let config = Configuration(model: model)

        let persistentStoreOptions = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]

        let url = self.applicationDocumentsDirectory.appendingPathComponent("db.sqlite")

        config.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .SQLite, url: url, configuration: nil, options: persistentStoreOptions as [String: AnyObject]))

        manager = Manager(configuration: config)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        manager.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        manager.saveContext()
    }


}

