//
//  Service.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/15/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import Foundation

class DataService {
    static let instance = DataService()
    
    private var payment: Payment?
    
    func setPayment(_ payment: Payment) {
        self.payment = payment
    }
    
    func getPayment() -> Payment? {
        if let payment = payment {
            return Payment(payment: payment)
        }
        return nil
    }
}
