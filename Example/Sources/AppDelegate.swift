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

    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Remove old db files
        let fileManager = NSFileManager()
        if let path = self.applicationDocumentsDirectory.URLByAppendingPathComponent("db.sqlite").path {
            do {
                try fileManager.removeItemAtPath(path)
            } catch {
                
            }
        }

        // Init Glover
        let model = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!)!
        let config = Configuration(model: model)

        let persistentStoreOptions = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]

        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("db.sqlite")

        config.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .SQLite, url: url, configuration: nil, options: persistentStoreOptions))

        manager = Manager(configuration: config)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        manager.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        manager.saveContext()
    }


}

