//
//  AppDelegate.swift
//  EmployeeList
//
//  Created by Mazharul Huq on 2/24/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager:DataManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.dataManager = DataManager(dataModel: "EmployeeList")
        self.dataManager.coreDataStack.cleanEntity(entityName: "Employee")
        self.dataManager.coreDataStack.cleanEntity(entityName: "Department")
        let nvc = self.window?.rootViewController as! UINavigationController
        let vc = nvc.topViewController as! ViewController
        vc.dataManager = self.dataManager
        return true
    }

    
}

