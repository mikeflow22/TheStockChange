//
//  IntradayPrices.swift
//  StockChange
//
//  Created by Michael Flowers on 3/23/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
/*
 
 "date": "2020-03-23",
 "minute": "09:30",
 "label": "09:30 AM",
 "high": 23.845,
 "low": 23.78,
 "open": 23.815,
 "close": 23.78,
 "average": 23.816,
 "volume": 700,
 "notional": 16671.3,
 "numberOfTrades": 5
 
 */

struct IntradayPrices: Codable {
    let date: String
    let minute: String
    let label: String?
    let high: Double?
    let low: Double?
    let open: Double?
    let close: Double?
    let average: Double?
    let volume: Double
    let notional: Double
    let numberOfTrades: Double
}
