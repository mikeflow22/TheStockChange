//
//  StockWatchListTableViewController.swift
//  StockChange
//
//  Created by Michael Flowers on 3/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class StockWatchListTableViewController: UITableViewController {
    let activityIndicator = UIActivityIndicatorView()
    let stockController = StockController.shared
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockController.fetchedResultsController.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 120.0, target: self, selector: #selector(refreshNotification), userInfo: nil, repeats: true)
        setUpActivityController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    func setUpActivityController(){
        activityIndicator.frame.size.height = view.frame.size.height / 2
        activityIndicator.frame.size.width = view.frame.size.width / 2
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    @objc func refreshNotification(){
        print("auto refresh initiated")
        refresh()
    }
    
    //this should be a notification with timeInterval for every 2 minutes to refresh the page.
    func refresh(){
       print("refreshing stock wish list tableView")
        stockController.fetchCoreDataStocksAndUpdateWithFetchedStockReps()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! StockWishCellTableViewCell
        let stock = stockController.fetchedResultsController.object(at: indexPath)
        cell.stock = stock
        cell.delegate = self

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let stockToDelete = stockController.fetchedResultsController.object(at: indexPath)
            stockController.deleteStock(stockToDelete)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockDetail" {
            guard let destination = segue.destination as? StockDetailViewController, let index = tableView.indexPathForSelectedRow else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            let stockToPass = stockController.fetchedResultsController.object(at: index)
            if let symbol = stockToPass.symbol {
                destination.stockSymbol = symbol
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
        }
    }
}

extension StockWatchListTableViewController: StockWishCellDelegate {
    func deleteStockAt(cell: UITableViewCell) {
        print("in delegate method")
        guard let index = tableView.indexPath(for: cell) else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let stockToDelete = stockController.fetchedResultsController.object(at: index)
        stockController.deleteStock(stockToDelete)
        print("deleted stock")
    }
}
