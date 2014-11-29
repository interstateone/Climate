//
//  ViewController.swift
//  Climate
//
//  Created by Brandon Evans on 2014-07-18.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var lastUpdatedButton: UIButton!

    private var feed: Feed?
    private let feedFormatter = FeedFormatter()

    private let lastUpdatedFormatter = TTTTimeIntervalFormatter()
    private var updateLabelTimer: NSTimer?
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let groupUserDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            if let feedID = groupUserDefaults.valueForKey(SettingsFeedIDKey) as? NSString {
                feed = Feed(feedID: feedID, handler: { [weak self] in
                    if let viewController = self {
                        viewController.updateUI()
                        viewController.updateLastUpdatedLabel()
                    }
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLabelTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateLastUpdatedLabel", userInfo: nil, repeats: true);
        updateLabelTimer!.tolerance = 0.5

        if let feed = feed {
            feed.fetchIfNotSubscribed()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        updateLabelTimer?.invalidate()
        updateLabelTimer = nil
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath) as DataCell

        if let feed = feed {
            let stream = feed.streams[indexPath.row] as XivelyDatastreamModel
            cell.nameLabel.text = feedFormatter.humanizeStreamName(stream.info["id"] as NSString)
            let unit = stream.info["unit"] as NSDictionary
            let symbol = unit["symbol"] as NSString

            let valueString = (stream.info["current_value"] as NSString) ?? "0"
            let value = valueString.floatValue
            cell.valueLabel.attributedText = feedFormatter.formatValue(value, symbol: symbol)
        }
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let streamCount = feed?.streams.count ?? 0
        return streamCount
    }
    
    // MARK: Actions
    
    @IBAction func fetchFeed(sender: AnyObject?) {
        feed?.fetchIfNotSubscribed()
    }
    
    // MARK: Private
    
    private func updateUI() {
        dataTableView.reloadData()
    }
    
    internal func updateLastUpdatedLabel() {
        if feed?.isSubscribed ?? false {
            lastUpdatedButton.setTitle("Auto-updating", forState: .Normal)
        }
        else if let date = NSUserDefaults.standardUserDefaults().valueForKey(DataLastUpdatedKey) as? NSDate {
            lastUpdatedButton.setTitle("Last updated \(lastUpdatedFormatter.stringForTimeIntervalFromDate(NSDate(), toDate: date))", forState: .Normal)
        }
    }
}

