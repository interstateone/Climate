//
//  Feed.swift
//  Climate
//
//  Created by Brandon Evans on 2014-11-28.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

class Feed: NSObject, XivelySubscribableDelegate, XivelyModelDelegate {
    internal let updateHandler: () -> Void
    internal var isSubscribed: Bool {
        return feed.isSubscribed
    }
    internal var streams: [AnyObject] {
        return feed.datastreamCollection.datastreams
    }
    private let feed = XivelyFeedModel()

    // MARK: Lifecycle

    init(feedID: String, handler: () -> Void) {
        updateHandler = handler

        super.init()

        feed.delegate = self
        feed.info["id"] = feedID
        feed.fetch()
        feed.subscribe()
    }

    deinit {
        if (feed.isSubscribed) {
            feed.unsubscribe()
        }
    }

    // MARK: Public Methods

    func subscribe() {
        feed.subscribe()
    }

    func unsubscribe() {
        feed.unsubscribe()
    }

    func fetchIfNotSubscribed() {
        if !feed.isSubscribed {
            feed.fetch()
        }
    }

    // MARK: Xively Delegates

    func modelUpdatedViaSubscription(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: DataLastUpdatedKey)
        updateHandler()
    }

    func modelDidFetch(model: XivelyModel!) {
        NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: DataLastUpdatedKey)
        updateHandler()
    }
}
