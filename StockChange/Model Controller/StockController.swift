//
//  StockController.swift
//  StockChange
//
//  Created by Michael Flowers on 3/20/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

class StockController {
    static let shared = StockController()
    
    var fetchedResultsController: NSFetchedResultsController<Stock> = {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "changePercent", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try frc.performFetch()
            print("performing fetch of the fetchedResultsController")
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
        }
        return frc
    }()
    
    //This function will update stocks in core data with their representation from the server.
    func fetchCoreDataStocksAndUpdateWithFetchedStockReps(){
          guard let stocksInCoreData = fetchedResultsController.fetchedObjects else {
              print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
              return
          }
          
          for stock in stocksInCoreData {
              if let symbol = stock.symbol{
                NetworkController.shared.getoStockRepresentationforStock(withSymbol: symbol) { (stockRep, error) in
                      if let error = error {
                          print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                          return
                      }
                      
                      guard let returnedStockRep = stockRep else {
                          print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                          return
                      }
                    self.updateStockInCoreData(stock: stock, withStockRep: returnedStockRep)
                  }
              } else {
                  print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
              }
          }
      }
    
    func updateStockInCoreData(stock: Stock, withStockRep stockRep: StockRepresentation){
        stock.latestPrice = stockRep.latestPrice
        stock.iexRealtimePrice = stockRep.iexRealtimePrice ?? 0.0
        stock.previousClose = stockRep.previousClose
        stock.change = stockRep.change ?? 0.0
        stock.changePercent = stockRep.changePercent ?? 0.0
        stock.marketCap = stockRep.marketCap
        stock.week52High = stockRep.week52High
        stock.week52Low = stockRep.week52Low
        saveToPersistentStore()
    }
    
    //MIGHT NEED A CONTEXT IN THE DECLARATION
    func checkToSeeIfStockIsInCoreDataWithTheSymbol(symbol: String) -> Stock? {
        //create fetchRequest that will fetch a stock using a predicate
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        let predicate = NSPredicate(format: "symbol == %@", symbol)
        fetchRequest.predicate = predicate
        
        //create an optional stock so that we can return it
        var stock: Stock? = nil
        
        do {
            //remember you want one so use the first instance you find in the array
            stock = try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
            //set the stock to nil
            stock = nil
        }
        
        return stock
    }
    
    func toggleIsOnWatchListForStock(stock: Stock){
        stock.isOnWishList.toggle()
        saveToPersistentStore()
    }
    
    func deleteStock(_ stock: Stock){
        stock.managedObjectContext?.delete(stock)
        saveToPersistentStore()
    }
    
    func createStockFrom(stockRepresentation: StockRepresentation){
        Stock(stockRepresentation: stockRepresentation)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore(){
        do {
            try CoreDataStack.shared.mainContext.save()
            print("saved the mainContext")
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
        }
    }
}
