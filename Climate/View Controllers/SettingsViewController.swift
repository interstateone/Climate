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
let SettingsSelectedTodayStreamsKey = "SettingsSelectedTodayStreams"
let DataLastUpdatedKey = "DataLastUpdated"

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var feedIDTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    private let streams: [String] = {
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            let streams = groupDefaults.objectForKey("AvailableStreamNames") as [String]
            return streams
        }
        return []
    }()

    private let formatter = FeedFormatter()

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

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streams.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsStreamCell", forIndexPath: indexPath) as UITableViewCell

        if let label = cell.textLabel {
            label.text = formatter.humanizeStreamName(streams[indexPath.row])
        }

        if (streamIsSelectedAtIndex(indexPath.row)) {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }

        return cell
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        if let cell = cell {
            switch cell.accessoryType {
            case .None:
                if numberOfSelectedStreams() >= 3 {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    return
                }
                cell.accessoryType = .Checkmark
            default:
                cell.accessoryType = .None
            }

            toggleStreamSelectedAtIndex(indexPath.row)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        updateDefaultsForTextField(textField)
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        updateDefaultsForTextField(textField)
    }

    // MARK: Actions
    
    @IBAction func dismissSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Private

    private func numberOfSelectedStreams() -> Int {
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            let streams = groupDefaults.objectForKey(SettingsSelectedTodayStreamsKey) as? [String]
            return streams?.count ?? 0
        }
        return 0
    }

    private func streamIsSelectedAtIndex(index: Int) -> Bool {
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            let storedStreams = groupDefaults.objectForKey(SettingsSelectedTodayStreamsKey) as? [String]
            return contains(storedStreams ?? [], streams[index])
        }
        return false
    }

    private func toggleStreamSelectedAtIndex(index: Int) {
        let streamName = streams[index]
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            var storedStreams = groupDefaults.objectForKey(SettingsSelectedTodayStreamsKey) as? [String]
            if storedStreams == nil {
                storedStreams = []
            }
            if var streams = storedStreams {
                if contains(streams, streamName) {
                    removeAtIndex(&streams, find(streams, streamName)!)
                }
                else {
                    streams.append(streamName)
                }
                groupDefaults.setObject(streams, forKey: SettingsSelectedTodayStreamsKey)
            }
        }
    }

    private func updateDefaultsForTextField(textField: UITextField) {
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
    }
}
