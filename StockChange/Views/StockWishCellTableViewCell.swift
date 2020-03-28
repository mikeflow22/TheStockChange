//
//  StockWishCellTableViewCell.swift
//  StockChange
//
//  Created by Michael Flowers on 3/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
protocol StockWishCellDelegate: class {
    func deleteStockAt(cell: UITableViewCell)
}

class StockWishCellTableViewCell: UITableViewCell {
    var delegate: StockWishCellDelegate?
    var stock: Stock? {
        didSet {
//            print("stock was hit in stock wish list cell")
            updateViews()
        }
    }
    
       @IBOutlet weak var stockSymbolLabel: UILabel!
       @IBOutlet weak var stockNameLabel: UILabel!
       @IBOutlet weak var stockPercentChangeLabel: UILabel!
       @IBOutlet weak var wishListButtonProperties: UIButton!

    @IBAction func removeWishListButtonTapped(_ sender: UIButton) {
        //delegate
        delegate?.deleteStockAt(cell: self)
        print("remove wish list button hit")
    }
    
    private func updateViews(){
        guard let passedInStock = stock else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }

        let positiveDouble = Double(passedInStock.changePercent * 100)
       
        if positiveDouble < 0.0 {
            stockPercentChangeLabel.textColor = .red
            stockSymbolLabel.text = passedInStock.symbol
            stockNameLabel.text = passedInStock.companyName
            let doubleString = String(format: "%.3f", positiveDouble)
            stockPercentChangeLabel.text = "change percentage: \(doubleString)%"
            wishListButtonProperties.setImage(UIImage(named: "highlightedStar"), for: .normal)
        } else {
        stockPercentChangeLabel.textColor = .green
        stockSymbolLabel.text = passedInStock.symbol
        stockNameLabel.text = passedInStock.companyName
        let doubleString = String(format: "%.3f", positiveDouble)
        stockPercentChangeLabel.text = "change percentage: \(doubleString)%"
        wishListButtonProperties.setImage(UIImage(named: "highlightedStar"), for: .normal)
        }
    }
}
