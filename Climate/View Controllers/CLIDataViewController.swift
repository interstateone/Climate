//
//  ViewController.swift
//  Climate
//
//  Created by Brandon Evans on 2014-07-18.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

class CLIDataViewController: UIViewController, XivelySubscribableDelegate, XivelyModelDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var dataTableView: UITableView
    
    let feed = XivelyFeedModel()
    
    init(coder aDecoder: NSCoder!)  {
        feed.info["id"] = "1726176956"
        
        super.init(coder: aDecoder)

        feed.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feed.fetch()
        feed.subscribe()
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
        let cell: CLIDataCell = tableView.dequeueReusableCellWithIdentifier("CLIDataCell", forIndexPath: indexPath) as CLIDataCell
        
        let stream = self.feed.datastreamCollection.datastreams[indexPath.row] as XivelyDatastreamModel
        cell.nameLabel.text = _humanizeStreamName(stream.info["id"] as NSString)
        cell.valueLabel.text = _formatValue((stream.info["current_value"] as NSString).floatValue)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        let streamCount = self.feed.datastreamCollection.datastreams.count
        return streamCount
    }
    
    // Private
    
    func _updateUI() {
        self.dataTableView.reloadData()
    }
    
    func _humanizeStreamName(streamName: String) -> String {
        return join(" ", streamName.componentsSeparatedByString("_"))
    }
    
    func _formatValue(value: Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.roundingMode = .RoundHalfUp
        formatter.maximumFractionDigits = 2
        formatter.maximumSignificantDigits = 9
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        
        return formatter.stringFromNumber(value)
    }
}

