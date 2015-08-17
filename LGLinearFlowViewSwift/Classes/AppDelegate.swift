//
//  AppDelegate.swift
//  LGLinearFlowViewSwift
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

}

