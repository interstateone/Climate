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

class SettingsViewController: UITableViewController, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet var apiKeyTextField: UITextField
    @IBOutlet var feedIDTextField: UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apiKey = NSUserDefaults.standardUserDefaults().valueForKey(SettingsAPIKeyKey) as? NSString {
            apiKeyTextField.text = apiKey
        }
        
        if let feedID = NSUserDefaults.standardUserDefaults().valueForKey(SettingsFeedIDKey) as? NSString {
            feedIDTextField.text = feedID
        }
    }
    
    // UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        switch textField {
        case apiKeyTextField:
            NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: SettingsAPIKeyKey)
        case feedIDTextField:
            NSUserDefaults.standardUserDefaults().setValue(textField.text, forKey: SettingsFeedIDKey)
        default:
            println()
        }
        return true
    }

    // Actions
    
    @IBAction func dismissSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
