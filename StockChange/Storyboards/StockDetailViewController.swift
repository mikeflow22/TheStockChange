//
//  StockDetailViewController.swift
//  StockChange
//
//  Created by Michael Flowers on 3/23/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit
import Charts

class StockDetailViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView()
    
    var stockSymbol: String? {
        didSet {
            print("Stock was hit")
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var months: [String]!
    
    var timeLabels: [String]? { //x axis
        didSet {
            print("timeLabels array hit")
        }
    }
    var priceAverages: [Double]? { //y axis
        didSet {
            print("priceAverages array hit")
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
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
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: print("segmented case 0") ; getIntradayPrices()
        case 1: print("segmented case 1") ; get5dayChange()
        case 2: print("segmented case 2") ; get30dayChange()
        default: print("segmented case out of range")
        }
    }
    
    func get30dayChange(){
        guard let passedInSymbol = stockSymbol else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let thirtyDay: Bool = segmentedControl.selectedSegmentIndex == 2
        activityIndicator.startAnimating()
        NetworkController.shared.getMultipleDayChangesForStock(withSymbol: passedInSymbol, thirtyDayChange: thirtyDay) { (thirtyDayChanges, error) in
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error getting 30 Day Stock Change information from server.", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let thirtyDayChanges = thirtyDayChanges else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            let pricesWithLabels = thirtyDayChanges.filter { $0.label != nil }
            let pricesWithLabelsAndPriceAverages = pricesWithLabels.filter { $0.change != nil }
            
            DispatchQueue.main.async {
                self.timeLabels = pricesWithLabelsAndPriceAverages.compactMap { $0.label }
                self.priceAverages = pricesWithLabelsAndPriceAverages.compactMap { ($0.changePercent) }.map { $0.rounded()}
                print("timeLables count: \(String(describing: self.timeLabels?.count))")
                print("priceAverages count: \(String(describing: self.priceAverages?.count))")
                self.setChart(dataPoints: self.timeLabels ?? [], values: self.priceAverages ?? [], label: "Percent Change")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func get5dayChange(){
        guard let passedInSymbol = stockSymbol else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        let fiveDay: Bool = segmentedControl.selectedSegmentIndex == 1
        activityIndicator.startAnimating()
        NetworkController.shared.getMultipleDayChangesForStock(withSymbol: passedInSymbol, fiveDayChange: fiveDay) { (fiveDayChanges, error) in
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error getting 5 Day Stock Change information from server.", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let returnedFiveDayChanges = fiveDayChanges else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            let pricesWithLabels = returnedFiveDayChanges.filter { $0.label != nil }
            let pricesWithLabelsAndPriceAverages = pricesWithLabels.filter { $0.change != nil }
            
            DispatchQueue.main.async {
                self.timeLabels = pricesWithLabelsAndPriceAverages.compactMap { $0.label }
                self.priceAverages = pricesWithLabelsAndPriceAverages.compactMap { ($0.changePercent) }.map { $0.rounded()}
                print("timeLables count: \(String(describing: self.timeLabels?.count))")
                print("priceAverages count: \(String(describing: self.priceAverages?.count))")
                self.setChart(dataPoints: self.timeLabels ?? [], values: self.priceAverages ?? [], label: "Percent Change")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func getIntradayPrices(){
        guard let passedInSymbol = stockSymbol else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        activityIndicator.startAnimating()
        NetworkController.shared.getIntradayPricesFor(stockSymbol: passedInSymbol, forInterval: 30) { (prices, error) in
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error getting Intraday Day Stock Change information from server.", message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let prices = prices else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            
            let pricesWithLabels = prices.filter { $0.label != nil }
            let pricesWithLabelsAndPriceAverages = pricesWithLabels.filter { $0.average != nil }
            
            DispatchQueue.main.async {
                self.timeLabels = pricesWithLabelsAndPriceAverages.compactMap { $0.label }
                self.priceAverages = pricesWithLabelsAndPriceAverages.compactMap { $0.average }
                
                print("timeLables count: \(String(describing: self.timeLabels?.count))")
                print("priceAverages count: \(String(describing: self.priceAverages?.count))")
                self.setChart(dataPoints: self.timeLabels ?? [], values: self.priceAverages ?? [], label: "Stock Price")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func updateViews(){
        guard let passedInSymbol = stockSymbol else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        self.title = "Stock Symbol: \(passedInSymbol)"
        getIntradayPrices()
    }
    
    func setChart(dataPoints: [String], values: [Double], label: String) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = [UIColor(red: 235/255, green: 158/255, blue: 32/255, alpha: 1)]
        chartDataSet.lineWidth = 5.0
        chartDataSet.circleColors = ChartColorTemplates.colorful()
        let color = UIColor(red: 235/255, green: 174/255, blue: 89/255, alpha: 1)
        chartDataSet.circleHoleColor = color
        chartDataSet.valueColors = [UIColor.black]
        
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        
        //initialize an IndexAxisValueFormatter with the  dataPoints
        let xAxisLabel = IndexAxisValueFormatter(values: dataPoints)
        
        //assign xAxislabel to xAxis instance property on barChartView
        lineChartView.xAxis.valueFormatter = xAxisLabel
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 9.0)
        lineChartView.xAxis.labelTextColor = .black
        
        //configure xAxis properties
        lineChartView.xAxis.labelPosition = .bothSided
        
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 0.1, easingOption: .linear)
        lineChartView.backgroundColor = .cyan
    }
}
