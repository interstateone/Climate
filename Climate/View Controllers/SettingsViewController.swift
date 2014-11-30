//
//  CLISettingsViewController.swift
//  Climate
//
//  Created by Brandon Evans on 2014-07-18.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

let SettingsAPIKeyKey = "SettingsAPIKey"
let SettingsFeedIDKey = "SettingsFeedID"
let DataLastUpdatedKey = "DataLastUpdated"

class SettingsViewController: UITableViewController, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet var apiKeyTextField: UITextField!
    @IBOutlet var feedIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            if let apiKey = groupDefaults.valueForKey(SettingsAPIKeyKey) as? NSString {
                apiKeyTextField.text = apiKey
            }
            
            if let feedID = groupDefaults.valueForKey(SettingsFeedIDKey) as? NSString {
                feedIDTextField.text = feedID
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            switch textField {
            case apiKeyTextField:
                groupDefaults.setValue(textField.text, forKey: SettingsAPIKeyKey)
            case feedIDTextField:
                groupDefaults.setValue(textField.text, forKey: SettingsFeedIDKey)
            default:
                println()
            }
        }
        return true
    }

    // MARK: Actions
    
    @IBAction func dismissSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
