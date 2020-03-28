//
//  FiveDayChange.swift
//  StockChange
//
//  Created by Michael Flowers on 3/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
/*
 "date": "2020-03-18",
 "open": 23.72,
 "close": 23,
 "high": 24.19,
 "low": 20,
 "volume": 31312654,
 "uOpen": 23.35,
 "uClose": 22,
 "uHigh": 23.52,
 "uLow": 20,
 "uVolume": 31589534,
 "change": -2.5,
 "changePercent": -10.6004,
 "label": "Mar 18",
 "changeOverTime": -0.102455
 */

struct multipleDayChange: Codable {
    let date: String
    let label: String?
    let open: Double
    let close: Double
    let change: Double?
    let changePercent: Double?
    let changeOverTime: Double?

}
