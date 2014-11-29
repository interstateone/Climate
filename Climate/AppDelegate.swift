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
        setupAppearance()
        setupDefaults()
        XivelyAPI.defaultAPI().apiKey = NSUserDefaults.standardUserDefaults().valueForKey(SettingsAPIKeyKey) as NSString
        return true
    }
    
    // MARK: Private
    
    private func setupAppearance() {
        let oldTitleBarAttributes = UINavigationBar.appearance().titleTextAttributes ?? Dictionary()
        let titleBarAttributes = NSMutableDictionary(dictionary:oldTitleBarAttributes)
        titleBarAttributes[NSFontAttributeName] = UIFont(name:"AvenirNext-Bold", size:16)
        titleBarAttributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        UINavigationBar.appearance().titleTextAttributes = titleBarAttributes;

        let oldBarButtonAttributes = UIBarButtonItem.appearance().titleTextAttributesForState(.Normal) ?? Dictionary();
        let barButtonAttributes = NSMutableDictionary(dictionary:oldBarButtonAttributes)
        barButtonAttributes[NSFontAttributeName] = UIFont(name:"Avenir Next", size:16)
        barButtonAttributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, forState: .Normal)
    }
    
    private func setupDefaults() {
        NSUserDefaults.standardUserDefaults().registerDefaults([SettingsAPIKeyKey: "MW49RcKFip8v8oxaZ7BQsfhE42FBhThL42lPuQFoGyZBe66g", SettingsFeedIDKey: "1726176956"])
    }
}

