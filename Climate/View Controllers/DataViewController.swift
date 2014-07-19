//
//  ViewController.swift
//  Climate
//
//  Created by Brandon Evans on 2014-07-18.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

let DataLastUpdatedKey = "DataLastUpdated"

class DataViewController: UIViewController, XivelySubscribableDelegate, XivelyModelDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var dataTableView: UITableView
    @IBOutlet var lastUpdatedButton: UIButton
    
    let feed = XivelyFeedModel()
    let lastUpdatedFormatter = TTTTimeIntervalFormatter()
    let valueFormatter = NSNumberFormatter()
    var updateLabelTimer: NSTimer?
    
    init(coder aDecoder: NSCoder!)  {
        valueFormatter.roundingMode = .RoundHalfUp
        valueFormatter.maximumFractionDigits = 0
        valueFormatter.groupingSeparator = " "
        valueFormatter.groupingSize = 3
        valueFormatter.usesGroupingSeparator = true
        
        super.init(coder: aDecoder)
        feed.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupFeed()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        _setupFeed()
        updateLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "_updateLastUpdatedLabel", userInfo: nil, repeats: true);
        updateLabelTimer!.tolerance = 0.5
    }
    
    override func viewDidDisappear(animated: Bool) {
        _tearDownFeed()
        updateLabelTimer?.invalidate()
        updateLabelTimer = nil
    }
    
    // Xively Delegates
    
    func modelUpdatedViaSubscription(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: DataLastUpdatedKey)
        _updateUI()
        _updateLastUpdatedLabel()
    }
    
    func modelDidFetch(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: DataLastUpdatedKey)
        _updateUI()
        _updateLastUpdatedLabel()
    }
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath) as DataCell
        
        let stream = self.feed.datastreamCollection.datastreams[indexPath.row] as XivelyDatastreamModel
        cell.nameLabel.text = _humanizeStreamName(stream.info["id"] as NSString)
        let unit = stream.info["unit"] as NSDictionary
        let symbol = unit["symbol"] as NSString
        cell.valueLabel.attributedText = _formatValue((stream.info["current_value"] as NSString).floatValue, symbol: symbol)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let streamCount = self.feed.datastreamCollection.datastreams.count
        return streamCount
    }
    
    // Actions
    
    @IBAction func fetchFeed(sender: AnyObject?) {
        if !feed.isSubscribed {
            feed.fetch()
        }
    }
    
    // Private
    
    func _setupFeed() {
        feed.info["id"] = NSUserDefaults.standardUserDefaults().valueForKey(SettingsFeedIDKey)
        
        self.fetchFeed(nil)
        if (!feed.isSubscribed) {
            feed.subscribe()
        }
    }
    
    func _tearDownFeed() {
        if (feed.isSubscribed) {
            feed.unsubscribe()
        }
    }
    
    func _updateUI() {
        self.dataTableView.reloadData()
    }
    
    func _humanizeStreamName(streamName: String) -> String {
        return join(" ", streamName.componentsSeparatedByString("_"))
    }
    
    func _formatValue(value: Float, symbol: String) -> NSAttributedString {
        let string = NSMutableAttributedString(string: "\(valueFormatter.stringFromNumber(value)) \(symbol)")
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(string.length - countElements(symbol), countElements(symbol)))
        return string
    }
    
    func _updateLastUpdatedLabel() {
        if feed.isSubscribed {
            lastUpdatedButton.setTitle("Auto-updating", forState: .Normal)
        }
        else if let date = NSUserDefaults.standardUserDefaults().valueForKey(DataLastUpdatedKey) as? NSDate {
            lastUpdatedButton.setTitle("Last updated \(lastUpdatedFormatter.stringForTimeIntervalFromDate(NSDate.date(), toDate: date))", forState: .Normal)
        }
    }
}

