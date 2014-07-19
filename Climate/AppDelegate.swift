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
        _setupAppearance()
        _setupDefaults()
        XivelyAPI.defaultAPI().apiKey = NSUserDefaults.standardUserDefaults().valueForKey(SettingsAPIKeyKey) as NSString

        return true
    }
    
    // Private
    
    func _setupAppearance() {
        let titleBarAttributes = NSMutableDictionary(dictionary:UINavigationBar.appearance().titleTextAttributes)
        titleBarAttributes[NSFontAttributeName] = UIFont(name:"AvenirNext-Bold", size:16)
        titleBarAttributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        UINavigationBar.appearance().titleTextAttributes = titleBarAttributes;
        
        let barButtonAttributes = NSMutableDictionary(dictionary:UIBarButtonItem.appearance().titleTextAttributesForState(.Normal))
        barButtonAttributes[NSFontAttributeName] = UIFont(name:"Avenir Next", size:16)
        barButtonAttributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, forState: .Normal)
    }
    
    func _setupDefaults() {
        NSUserDefaults.standardUserDefaults().registerDefaults([SettingsAPIKeyKey: "MW49RcKFip8v8oxaZ7BQsfhE42FBhThL42lPuQFoGyZBe66g", SettingsFeedIDKey: "1726176956"])
    }
}

