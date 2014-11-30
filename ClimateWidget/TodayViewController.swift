//
//  TodayViewController.swift
//  ClimateWidget
//
//  Created by Brandon Evans on 2014-11-28.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    private var feed: Feed?
    private let feedFormatter = FeedFormatter()
    private var selectedStreams: [AnyObject]?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = CGSize(width: 0, height: 80)

        if let groupUserDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            groupUserDefaults.synchronize()
            XivelyAPI.defaultAPI().apiKey = groupUserDefaults.valueForKey(SettingsAPIKeyKey) as? NSString
            if let feedID = groupUserDefaults.valueForKey(SettingsFeedIDKey) as? NSString {
                feed = Feed(feedID: "1726176956", handler: { [weak self] in
                    if let viewController = self {
                        viewController.updateUI()
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: NCWidgetProviding
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        feed?.fetchIfNotSubscribed()
        updateUI()

        completionHandler(NCUpdateResult.NewData)
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = selectedStreams?.count ?? 0
        return count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClimateWidgetCell", forIndexPath: indexPath) as ClimateWidgetCell

        if let model = selectedStreams?[indexPath.row] as? XivelyDatastreamModel {
            let name = feedFormatter.humanizeStreamName(model.info["id"] as NSString)
            let unit = model.info["unit"] as NSDictionary
            let symbol = unit["symbol"] as NSString

            let valueString = (model.info["current_value"] as NSString) ?? "0"
            let value = valueString.floatValue

            if let valueLabel = cell.valueLabel {
                valueLabel.text = feedFormatter.formatValue(value, symbol: "").string
            }
            if let signLabel = cell.signLabel {
                signLabel.text = symbol
            }
            if let nameLabel = cell.nameLabel {
                nameLabel.text = name
            }
        }

        return cell
    }

    // MARK: Private

    private func updateUI() {
        if let groupDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
            if let selectedStreamNames = groupDefaults.objectForKey(SettingsSelectedTodayStreamsKey) as? [String] {
                if let feed = feed {
                    selectedStreams = filter(feed.streams, { (stream) -> Bool in
                        let s = stream as XivelyDatastreamModel
                        return contains(selectedStreamNames, s.info["id"] as String)
                    })
                }
            }
        }

        collectionView.reloadData()
    }
}
