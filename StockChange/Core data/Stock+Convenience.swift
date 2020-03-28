//
//  Stock+Convenience.swift
//  StockChange
//
//  Created by Michael Flowers on 3/20/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

extension Stock {
    @discardableResult
    convenience init(symbol: String, companyName: String, latestPrice: Double, iexRealtimePrice: Double, previousClose: Double, change: Double, changePercent: Double, marketCap: Double, week52High: Double, week52Low: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.symbol = symbol
        self.companyName = companyName
        self.latestPrice = latestPrice
        self.iexRealtimePrice = iexRealtimePrice
        self.previousClose = previousClose
        self.change = change
        self.changePercent = changePercent
        self.marketCap = marketCap
        self.week52High = week52High
        self.week52Low = week52Low
    }
    
    // turn the data we get back and parse it so that we can create a stock - when  we decode this shouldn't fail - now we can save this to core data
   @discardableResult
    convenience init(stockRepresentation: StockRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
    self.init(symbol: stockRepresentation.symbol, companyName: stockRepresentation.companyName, latestPrice: stockRepresentation.latestPrice, iexRealtimePrice: stockRepresentation.iexRealtimePrice ?? 0.0, previousClose: stockRepresentation.previousClose, change: stockRepresentation.change ?? 0.0, changePercent: stockRepresentation.changePercent ?? 0.0, marketCap: stockRepresentation.marketCap, week52High: stockRepresentation.week52High, week52Low: stockRepresentation.week52Low, context: context)
    }
}
