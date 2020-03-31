//
//  NetworkController.swift
//  StockChange
//

//  Created by Michael Flowers on 3/20/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.


import Foundation
class NetworkController {
    private let apiToken = APIKeys.apiToken
    private let baseURL = URL(string: "https://cloud.iexapis.com/stable/")!
//    private let baseURL = URL(string: "https://sandbox.iexapis.com/stable/")!
    
    private let gainersURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?listLimit=50&token=pk_5a7448e9cab94f6faa23f671495079af")!
    static let shared = NetworkController()
    
    func getMultipleDayChangesForStock(withSymbol symbol: String, fiveDayChange fiveDays: Bool? = false, thirtyDayChange thirtyDays: Bool? = false, completion: @escaping ([multipleDayChange]?, Error?) -> Void){
        //        https://sandbox.iexapis.com/stable/stock/twtr/chart/5d?token=Tsk_08af2b879ca5457fb3bee157c2c82b71
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let tokenQueryItem = URLQueryItem(name: "token", value: apiToken)
        urlComponents?.queryItems = [tokenQueryItem]
        var theURL: URL? {
            if fiveDays ==  true && thirtyDays == false {
                return urlComponents?.url?.appendingPathComponent("stock").appendingPathComponent(symbol).appendingPathComponent("chart").appendingPathComponent("5d")
            } else if fiveDays == false && thirtyDays == true {
                return urlComponents?.url?.appendingPathComponent("stock").appendingPathComponent(symbol).appendingPathComponent("chart").appendingPathComponent("1m")
            }  else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                print("NO URL")
                return nil
            }
        }
        
        guard let finalURL = theURL else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        print("this is the final url for function: \(#function) -> \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in function: \(#function): \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let arrayOfFiveDayChanges = try decoder.decode([multipleDayChange].self, from: data)
                completion(arrayOfFiveDayChanges, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func getIntradayPricesFor(stockSymbol: String, forInterval interval: Double, completion: @escaping ([IntradayPrices]?, Error?) -> Void) {
        //        let url = "https://cloud.iexapis.com/stable/stock/twtr/intraday-prices?chartInterval=30&token=pk_5a7448e9cab94f6faa23f671495079af"
        //
        //give premission to change url
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //add any queryItems
        let chartIntervalQueryItem = URLQueryItem(name: "chartInterval", value: "\(interval)")
        let tokenQueryItem = URLQueryItem(name: "token", value: apiToken)
        
        urlComponents?.queryItems = [chartIntervalQueryItem, tokenQueryItem]
        
        let appendedURL = urlComponents?.url?.appendingPathComponent("stock").appendingPathComponent(stockSymbol).appendingPathComponent("intraday-prices")
        
        guard let finalURL =  appendedURL else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        print("this is the finalurl for: \(#function) -> \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in function: \(#function): \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let arrayOfIntradayPrices = try decoder.decode([IntradayPrices].self, from: data)
                completion(arrayOfIntradayPrices, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func getoStockRepresentationforStock(withSymbol: String, completion: @escaping(StockRepresentation?, Error?) -> Void){
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let tokenQueryItem = URLQueryItem(name: "token", value: apiToken)
        urlComponents?.queryItems = [tokenQueryItem]
        
        let url4 = urlComponents?.url?.appendingPathComponent("stock").appendingPathComponent(withSymbol).appendingPathComponent("quote")
        
        guard let finalURL = url4 else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        print("final url:  \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in function: \(#function): \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let stockRep = try decoder.decode(StockRepresentation.self, from: data)
                completion(stockRep, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func searchForStock(withSymbol: String, completion: @escaping(StockRepresentation?, Error?) -> Void){
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let tokenQueryItem = URLQueryItem(name: "token", value: apiToken)
        urlComponents?.queryItems = [tokenQueryItem]
        
        let url4 = urlComponents?.url?.appendingPathComponent("stock").appendingPathComponent(withSymbol).appendingPathComponent("quote")
        
        guard let finalURL = url4 else {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
            return
        }
        
        print("final url:  \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in function: \(#function): \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let stockRep = try decoder.decode(StockRepresentation.self, from: data)
                completion(stockRep, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func getStocksWithLargestPercentageChange(completion: @escaping ([StockRepresentation]?, Error?) -> Void){
        
        URLSession.shared.dataTask(with: gainersURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in function: \(#function): \(response.statusCode)")
            }
            
            print(self.gainersURL)
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let stockReps = try decoder.decode([StockRepresentation].self, from: data)
                completion(stockReps, nil)
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
}
