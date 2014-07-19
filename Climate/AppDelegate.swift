//
//  AppDelegate.swift
//  Climate
//
//  Created by Brandon Evans on 2014-07-18.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        XivelyAPI.defaultAPI().apiKey = "MW49RcKFip8v8oxaZ7BQsfhE42FBhThL42lPuQFoGyZBe66g"
        
        let titleBarAttributes = NSMutableDictionary(dictionary:UINavigationBar.appearance().titleTextAttributes)
        titleBarAttributes[NSFontAttributeName] = UIFont(name:"AvenirNext-Bold", size:16)
        titleBarAttributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        UINavigationBar.appearance().titleTextAttributes = titleBarAttributes;

        return true
    }
}

