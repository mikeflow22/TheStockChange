//
//  StockRepresentation.swift
//  StockChange
//
//  Created by Michael Flowers on 3/20/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

struct StockRepresentation: Codable, Equatable {
    var symbol: String
    var companyName: String
    var latestPrice: Double
    var iexRealtimePrice: Double?
    var previousClose: Double
    var change: Double?
    var changePercent: Double?
    var marketCap: Double
    var week52High: Double
    var week52Low: Double
    var isOnWatchList: Bool?
}
