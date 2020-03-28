//
//  StockRepListTableViewController.swift
//  StockChange
//
//  Created by Michael Flowers on 3/21/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class StockRepListTableViewController: UITableViewController {
    var activityIndicator = UIActivityIndicatorView()
    var apiStockRepsArray: [StockRepresentation] = [] {
        didSet {
            print("apiStockRepsArray was hit")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityController()
    }
    
    func setUpActivityController(){
        activityIndicator.frame.size.height = view.frame.size.height / 2
        activityIndicator.frame.size.width = view.frame.size.width / 2
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func fetchStockReps(){
        activityIndicator.startAnimating()
        let networkController = NetworkController.shared
        networkController.getStocksWithLargestPercentageChange { (stockReps, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error getting largest Stock Change information from server.", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let returnedStockReps = stockReps else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            print("returnedStockReps count: \(returnedStockReps.count)")
            DispatchQueue.main.async {
                self.apiStockRepsArray = returnedStockReps
                print("apiStockRepArray count: \(self.apiStockRepsArray.count)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStockReps()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiStockRepsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockRepCell", for: indexPath) as! StockRepCellTableViewCell
        let stockRepresentation = apiStockRepsArray[indexPath.row]
        cell.stockRepresentation = stockRepresentation
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockDetail" {
            guard let destination = segue.destination as? StockDetailViewController, let index =  tableView.indexPathForSelectedRow else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            if self.apiStockRepsArray.count != 0  {
                let symbol = apiStockRepsArray[index.row].symbol
                destination.stockSymbol = symbol
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                print("no stockReps in stockRepsArray")
            }
        }
    }
}

extension StockRepListTableViewController: StockRepCellDelegate {
    func deleteStockAt(cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell) else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let stockRep = apiStockRepsArray[index.row]
        activityIndicator.startAnimating()
        if let stockToDelete = StockController.shared.checkToSeeIfStockIsInCoreDataWithTheSymbol(symbol: stockRep.symbol) {
            print("deleted stock from stockRep delegate method")
            StockController.shared.deleteStock(stockToDelete)
        } else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            print("no stock to delete \(#function)")
        }
        activityIndicator.stopAnimating()
    }
    
    func removeStockWithSameRep(symbol: StockRepresentation) {
        //remove stock from the array and populate the  tableView
        activityIndicator.startAnimating()
        apiStockRepsArray = apiStockRepsArray.filter { $0.symbol != symbol.symbol}
        activityIndicator.stopAnimating()
    }
}
