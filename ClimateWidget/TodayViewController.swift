//
//  TodayViewController.swift
//  ClimateWidget
//
//  Created by Brandon Evans on 2014-11-28.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var temperatureLabel: UILabel!

    private var feed: Feed?
    private let feedFormatter = FeedFormatter()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        XivelyAPI.defaultAPI().apiKey = "MW49RcKFip8v8oxaZ7BQsfhE42FBhThL42lPuQFoGyZBe66g"
//        if let groupUserDefaults = NSUserDefaults(suiteName: "group.brandonevans.Climate") {
//            if let feedID = groupUserDefaults.valueForKey(SettingsFeedIDKey) as? NSString {
                feed = Feed(feedID: "1726176956", handler: { [weak self] in
                    if let viewController = self {
                        viewController.updateUI()
                    }
                })
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        feed?.fetchIfNotSubscribed()
        updateUI()

        completionHandler(NCUpdateResult.NewData)
    }

    private func updateUI() {
        if let model = feed?.streams.first as? XivelyDatastreamModel {
            let name = feedFormatter.humanizeStreamName(model.info["id"] as NSString)
            let unit = model.info["unit"] as NSDictionary
            let symbol = unit["symbol"] as NSString

            let valueString = (model.info["current_value"] as NSString) ?? "0"
            let value = valueString.floatValue
            temperatureLabel.text = name + ": " + feedFormatter.formatValue(value, symbol: symbol).string
        }
    }
}
