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
    let lastUpdatedFormatter = NSDateFormatter()
    let valueFormatter = NSNumberFormatter()
    
    init(coder aDecoder: NSCoder!)  {
        lastUpdatedFormatter.dateStyle = .ShortStyle
        lastUpdatedFormatter.timeStyle = .ShortStyle
        lastUpdatedFormatter.doesRelativeDateFormatting = true
        
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        _tearDownFeed()
    }
    
    // Xively Delegates
    
    func modelDidSubscribe(model: XivelyModel!) {
        println("Web socket connected, receiving live updates")
    }
    
    func modelUpdatedViaSubscription(model: XivelyModel!) {
        _updateUI()
    }
    
    func modelDidFetch(model: XivelyModel!) {
        println("Datastream fetched")
        _updateUI()
    }
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath) as DataCell
        
        let stream = self.feed.datastreamCollection.datastreams[indexPath.row] as XivelyDatastreamModel
        cell.nameLabel.text = _humanizeStreamName(stream.info["id"] as NSString)
        let unit = stream.info["unit"] as NSDictionary
        let symbol = unit["symbol"] as NSString
        cell.valueLabel.text = _formatValue((stream.info["current_value"] as NSString).floatValue, symbol: symbol)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let streamCount = self.feed.datastreamCollection.datastreams.count
        return streamCount
    }
    
    // Actions
    
    @IBAction func fetchFeed(sender: AnyObject?) {
        feed.fetch()
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: DataLastUpdatedKey)
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
        if let date = NSUserDefaults.standardUserDefaults().valueForKey(DataLastUpdatedKey) as? NSDate {
            lastUpdatedButton.setTitle("Last updated: \(lastUpdatedFormatter.stringFromDate(date))", forState: .Normal)
        }
    }
    
    func _humanizeStreamName(streamName: String) -> String {
        return join(" ", streamName.componentsSeparatedByString("_"))
    }
    
    func _formatValue(value: Float, symbol: String) -> String {
        return "\(valueFormatter.stringFromNumber(value)) \(symbol)"
    }
}

