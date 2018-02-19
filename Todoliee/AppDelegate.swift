//
//  AppDelegate.swift
//  Todoliee
//
//  Created by Babak Farahanchi on 2018-02-04.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
//        print(Realm.Configuration.defaultConfiguration.fileURL)

        
        do{
        _ = try Realm()

        }catch{
            print("Error initializing Realm \(error)")
            
        }
        return true
    }



}

