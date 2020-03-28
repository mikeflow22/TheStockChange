//
//  UIViewController+Extensions.swift
//  StockChange
//
//  Created by Michael Flowers on 3/27/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
