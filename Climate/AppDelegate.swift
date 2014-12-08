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

        if let groupUserDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            XivelyAPI.defaultAPI().apiKey = groupUserDefaults.valueForKey(SettingsAPIKeyKey) as? NSString
        }

        return true
    }
    
    // MARK: Private
    
    private func setupAppearance() {
        let oldBarButtonAttributes = UIBarButtonItem.appearance().titleTextAttributesForState(.Normal) ?? Dictionary();
        let barButtonAttributes = NSMutableDictionary(dictionary:oldBarButtonAttributes)
        barButtonAttributes[NSFontAttributeName] = UIFont(name:"Avenir Next", size:16)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, forState: .Normal)
    }
    
    private func setupDefaults() {
        if let groupUserDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            groupUserDefaults.registerDefaults([SettingsAPIKeyKey: "MW49RcKFip8v8oxaZ7BQsfhE42FBhThL42lPuQFoGyZBe66g", SettingsFeedIDKey: "1726176956"])
        }
    }
}

