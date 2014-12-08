//
//  FeedFormatter.swift
//  Climate
//
//  Created by Brandon Evans on 2014-11-29.
//  Copyright (c) 2014 Brandon Evans. All rights reserved.
//

import UIKit

class FeedFormatter: NSObject {
    private let valueFormatter = NSNumberFormatter()

    override init() {
        valueFormatter.roundingMode = .RoundHalfUp
        valueFormatter.maximumFractionDigits = 0
        valueFormatter.groupingSeparator = " "
        valueFormatter.groupingSize = 3
        valueFormatter.usesGroupingSeparator = true

        super.init()
    }

    func humanizeStreamName(streamName: String) -> String {
        return join(" ", streamName.componentsSeparatedByString("_"))
    }

    func formatValue(value: Float, symbol: String) -> String {
        let value = valueFormatter.stringFromNumber(value) ?? "0"
        return "\(value) \(symbol)"
    }
}
