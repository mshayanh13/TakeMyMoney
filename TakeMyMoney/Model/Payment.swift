//
//  Payment.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/14/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import Foundation

struct CreditCard {
    let cardNumber: Int
    let cardHolder: String
    let validUntil: Date
    let cvv: Int
}

struct PayPal {
    let username: String
    let password: String
}

enum PaymentMethod: Int {
    case creditCard = 2
    case payPal = 3
}

struct Payment {
    var totalPrice: Double
    var paymentMethod: PaymentMethod
    var creditCard: CreditCard?
    var payPal: PayPal?
    
    init (totalPrice: Double, creditCard: CreditCard) {
        self.totalPrice = totalPrice
        self.paymentMethod = .creditCard
        self.creditCard = creditCard
        self.payPal = nil
    }
    
    init (totalPrice: Double, payPal: PayPal) {
        self.totalPrice = totalPrice
        self.paymentMethod = .payPal
        self.payPal = payPal
        self.creditCard = nil
    }
    
    init(payment: Payment) {
        self.totalPrice = payment.totalPrice
        self.paymentMethod = payment.paymentMethod
        self.creditCard = payment.creditCard
        self.payPal = payment.payPal
    }
    
    mutating func changeToCreditCard(_ creditCard: CreditCard) {
        self.paymentMethod = .creditCard
        self.creditCard = creditCard
        self.payPal = nil
    }
    
    mutating func changeToPayPal(_ payPal: PayPal) {
        self.paymentMethod = .payPal
        self.payPal = payPal
        self.creditCard = nil
    }
}
