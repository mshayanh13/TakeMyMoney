//
//  Helper.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/15/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

func getDateFrom(month: Int, year: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    
    let calendar = Calendar(identifier: .gregorian)
    if let date = calendar.date(from: components) {
        return date
    } else {
        return Date()
    }
}

extension UIViewController {
    func showPaymentErrorAlert() {
        let alert = UIAlertController(title: "", message: "Your Payment Has Failed.", preferredStyle: .alert)
        self.present(alert, animated: true)
        
        let secondsToDismissAlert = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: secondsToDismissAlert, execute: {
            alert.dismiss(animated: true)
            })
    }
}
