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
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var lastUpdatedButton: UIButton!
    
    private let feed = XivelyFeedModel()
    private let lastUpdatedFormatter = TTTTimeIntervalFormatter()
    private let valueFormatter = NSNumberFormatter()
    private var updateLabelTimer: NSTimer?
    
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
        setupFeed()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupFeed()
        updateLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLastUpdatedLabel", userInfo: nil, repeats: true);
        updateLabelTimer!.tolerance = 0.5
    }
    
    override func viewDidDisappear(animated: Bool) {
        tearDownFeed()
        updateLabelTimer?.invalidate()
        updateLabelTimer = nil
    }
    
    // MARK: Xively Delegates
    
    func modelUpdatedViaSubscription(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: DataLastUpdatedKey)
        updateUI()
        updateLastUpdatedLabel()
    }
    
    func modelDidFetch(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate.date(), forKey: DataLastUpdatedKey)
        updateUI()
        updateLastUpdatedLabel()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath) as DataCell
        
        let stream = self.feed.datastreamCollection.datastreams[indexPath.row] as XivelyDatastreamModel
        cell.nameLabel.text = humanizeStreamName(stream.info["id"] as NSString)
        let unit = stream.info["unit"] as NSDictionary
        let symbol = unit["symbol"] as NSString
        cell.valueLabel.attributedText = formatValue((stream.info["current_value"] as NSString).floatValue, symbol: symbol)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let streamCount = self.feed.datastreamCollection.datastreams.count
        return streamCount
    }
    
    // MARK: Actions
    
    @IBAction func fetchFeed(sender: AnyObject?) {
        if !feed.isSubscribed {
            feed.fetch()
        }
    }
    
    // MARK: Private
    
    private func setupFeed() {
        feed.info["id"] = NSUserDefaults.standardUserDefaults().valueForKey(SettingsFeedIDKey)
        
        self.fetchFeed(nil)
        if (!feed.isSubscribed) {
            feed.subscribe()
        }
    }
    
    private func tearDownFeed() {
        if (feed.isSubscribed) {
            feed.unsubscribe()
        }
    }
    
    private func updateUI() {
        self.dataTableView.reloadData()
    }
    
    private func humanizeStreamName(streamName: String) -> String {
        return join(" ", streamName.componentsSeparatedByString("_"))
    }
    
    private func formatValue(value: Float, symbol: String) -> NSAttributedString {
        let string = NSMutableAttributedString(string: "\(valueFormatter.stringFromNumber(value)) \(symbol)")
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(string.length - countElements(symbol), countElements(symbol)))
        return string
    }
    
    internal func updateLastUpdatedLabel() {
        if feed.isSubscribed {
            lastUpdatedButton.setTitle("Auto-updating", forState: .Normal)
        }
        else if let date = NSUserDefaults.standardUserDefaults().valueForKey(DataLastUpdatedKey) as? NSDate {
            lastUpdatedButton.setTitle("Last updated \(lastUpdatedFormatter.stringForTimeIntervalFromDate(NSDate.date(), toDate: date))", forState: .Normal)
        }
    }
}

