//
//  StockRepCellTableViewCell.swift
//  StockChange
//
//  Created by Michael Flowers on 3/21/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

protocol StockRepCellDelegate: class {
    func deleteStockAt(cell: UITableViewCell)
    func removeStockWithSameRep(symbol: StockRepresentation)
}

class StockRepCellTableViewCell: UITableViewCell {
    var delegate: StockRepCellDelegate?
    var didAddToWishList: Bool?
    var stockRepresentation: StockRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockPercentChangeLabel: UILabel!
    @IBOutlet weak var addToWishListButtonProperties: UIButton!
    
    @IBAction func addToWishListButtonTapped(_ sender: UIButton) {
        //initialize stock from stockRep
        guard let passedInStockRep = stockRepresentation else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        print("didAddToWishList when button is pressed\(String(describing: didAddToWishList))")
        if didAddToWishList == true {
            addToWishListButtonProperties.setImage(UIImage(named: "emptyStar"), for: .normal)
            delegate?.deleteStockAt(cell: self)
            delegate?.removeStockWithSameRep(symbol: passedInStockRep)
        } else {
            StockController.shared.createStockFrom(stockRepresentation: passedInStockRep)
            addToWishListButtonProperties.setImage(UIImage(named: "highlightedStar"), for: .normal)
        }
    }
    
    private func updateViews(){
        guard var passedInStock = stockRepresentation else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let positiveDouble = Double((passedInStock.changePercent ?? 0.0) * 100)
        
        //IF STOCK IS ALREADY IN CORE  DATA WE SHOULD NOT ALLOW USER TO PRESS BUTTON TO SAVE AGAIN
        if let stockIsAlreadyInCoreData = StockController.shared.checkToSeeIfStockIsInCoreDataWithTheSymbol(symbol: passedInStock.symbol){
            didAddToWishList = true
            print("didAddToWishList in updateViews \(String(describing: didAddToWishList))")
            //stock is already in core data so user should be able to remove it from wish list, which means remove it from core data
            stockSymbolLabel.text = stockIsAlreadyInCoreData.symbol
            stockNameLabel.text = stockIsAlreadyInCoreData.companyName
            let doubleString = String(format: "%.3f", positiveDouble)
            stockPercentChangeLabel.text = "change percentage: \(doubleString)%"
            addToWishListButtonProperties.setImage(UIImage(named: "highlightedStar"), for: .normal)
        } else {
            //stock isn't in core data so user should be able to add to wish list
            passedInStock.isOnWatchList = false
            stockSymbolLabel.text = passedInStock.symbol
            stockNameLabel.text = passedInStock.companyName
            let doubleString = String(format: "%.3f", positiveDouble)
            stockPercentChangeLabel.text = "change percentage: \(doubleString)%"
            addToWishListButtonProperties.setImage(UIImage(named: "emptyStar"), for: .normal)

        }
    }
}
