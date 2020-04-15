//
//  PaymentViewController.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/15/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var last4DigitsLabel: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
    }
    
    func setUpLabels() {
        nameLabel.text = ""
        last4DigitsLabel.text = ""
        if let payment = DataService.instance.getPayment() {
            if payment.paymentMethod == .creditCard {
                if let creditCard = payment.creditCard {
                    nameLabel.text = creditCard.cardHolder
                    last4DigitsLabel.text = "Last 4 Digits Ending In: \(getLast4From(creditCardNumber: creditCard.cardNumber))"
                    paymentImage.image = UIImage(named: "creditcard")
                }
            } else if payment.paymentMethod == .payPal {
                if let paypal = payment.payPal {
                    nameLabel.text = paypal.username
                    last4DigitsLabel.text = "*****"
                    paymentImage.image = UIImage(named: "paypal")
                }
            }
        }
    }
    
    func getLast4From(creditCardNumber: Int) -> String {
        var last4 = ""
        let array = Array(String(creditCardNumber))
        last4.append(array[array.count-4])
        last4.append(array[array.count-3])
        last4.append(array[array.count-2])
        last4.append(array[array.count-1])
        return last4
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        showPaymentErrorAlert()
    }

}
