//
//  PaymentDataTableViewController.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/14/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class PaymentDataTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var payPalButton: UIButton!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var creditCardNumberTextField: UITextField!
    @IBOutlet weak var creditCardCardholderNameTextField: UITextField!
    @IBOutlet weak var creditCardCvvTextField: UITextField!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var creditCardExpiryPickerView: MonthYearPickerView!
    @IBOutlet weak var payPalUsernameTextField: UITextField!
    @IBOutlet weak var payPalPasswordTextField: UITextField!
    @IBOutlet weak var purchaseButton: UIButton!
    var totalPrice = 786.99
    var currentMonth = 1
    var currentYear = 1
    let buttonsIndexPath = IndexPath(row: 0, section: 1)
    var currentCreditCardNumber = ""
    let expiryPickerIndexPath = IndexPath(row: 7, section: 2)
    var isExpiryPickerShown = false {
        didSet {
            creditCardExpiryPickerView.isHidden = !isExpiryPickerShown
        }
    }
    var sectionToHide: PaymentMethod = .payPal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = creditCardExpiryPickerView.month
        currentYear = creditCardExpiryPickerView.year
        
        creditCardNumberTextField.delegate = self
        creditCardCardholderNameTextField.delegate = self
        creditCardCvvTextField.delegate = self
        payPalUsernameTextField.delegate = self
        payPalPasswordTextField.delegate = self
        
        creditCardExpiryPickerView.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.expiryLabel.text = string
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
}

//Table View Functions
extension PaymentDataTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        switch (indexPath.section, indexPath.row) {
        case (expiryPickerIndexPath.section, expiryPickerIndexPath.row):
            if isExpiryPickerShown {
                height = 216.0
            } else {
                height = 0.0
            }
        case (buttonsIndexPath.section, buttonsIndexPath.row):
            height = 60.0
        default:
            height = 44.0
        }
        
        if sectionToHide == PaymentMethod(rawValue: indexPath.section) {
            height = 0.0
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (expiryPickerIndexPath.section, expiryPickerIndexPath.row - 1):
            if isExpiryPickerShown {
                isExpiryPickerShown = false
            } else {
                isExpiryPickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if PaymentMethod(rawValue: section) == sectionToHide {
            return 0.1
        } else {
            return 28
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if PaymentMethod(rawValue: section) == sectionToHide {
            return 0.1
        } else {
            return 28
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if PaymentMethod(rawValue: section) == sectionToHide {
            return UIView.init(frame: .zero)
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if PaymentMethod(rawValue: section) == sectionToHide {
            return UIView.init(frame: .zero)
        } else {
            return nil
        }
    }
}

//IBActions
extension PaymentDataTableViewController {
    
    @IBAction func unwindToPaymentDataVC(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func payPalButtonTapped(_ sender: UIButton) {
        payPalButton.isSelected = true
        creditCardButton.isSelected = false
        sectionToHide = .creditCard
        clearCreditCardFields()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func creditCardButtonTapped(_ sender: UIButton) {
        payPalButton.isSelected = false
        creditCardButton.isSelected = true
        sectionToHide = .payPal
        clearPayPalFields()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func purchaseButtonTapped(_ sender: UIButton) {
        if sectionToHide == .payPal {
            if let creditCardNumber = checkAndGetCreditCardNumber(), let creditCardHolder = checkAndGetCreditCardHolder(), let cvv = checkAndGetCreditCardCvv() {
                
                let expiryMonth = creditCardExpiryPickerView.month
                let expiryYear = creditCardExpiryPickerView.year
                
                let date = getDateFrom(month: expiryMonth, year: expiryYear)
                let creditCard = CreditCard(cardNumber: creditCardNumber, cardHolder: creditCardHolder, validUntil: date, cvv: cvv)
                DataService.instance.setPayment(Payment(totalPrice: totalPrice, creditCard: creditCard))
                performSegue(withIdentifier: "PaymentVC", sender: self)
            }
        } else if sectionToHide == .creditCard {
            if let username = checkAndGetUsername(), let password = checkAndGetPassword() {
                let paypal = PayPal(username: username, password: password)
                DataService.instance.setPayment(Payment(totalPrice: totalPrice, payPal: paypal))
                performSegue(withIdentifier: "PaymentVC", sender: self)
            }
        }
    }
}

//Helper Functions
extension PaymentDataTableViewController {
    func setupTableView() {
        setInitialCvvDate()
        removeKeyboard()
    }
    
    func setInitialCvvDate() {
        let month: Int = creditCardExpiryPickerView.month
        let year: Int = creditCardExpiryPickerView.year
        
        let string = String(format: "%02d/%d", month, year)
        self.expiryLabel.text = string
    }
    
    func removeKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func clearCreditCardFields() {
        creditCardCvvTextField.text = ""
        creditCardCardholderNameTextField.text = ""
        creditCardNumberTextField.text = ""
        
        creditCardExpiryPickerView.month = currentMonth
        creditCardExpiryPickerView.year = currentYear
        setInitialCvvDate()
    }
    
    func clearPayPalFields() {
        payPalPasswordTextField.text = ""
        payPalUsernameTextField.text = ""
    }
    
    func checkAndGetCreditCardNumber() -> Int? {
        if currentCreditCardNumber.count > 0 {
            if let creditCardNumber = Int(currentCreditCardNumber) {
                return creditCardNumber
            }
        }
        
        creditCardNumberTextField.layer.borderColor = UIColor.red.cgColor
        creditCardNumberTextField.layer.borderWidth = 1.0
        creditCardNumberTextField.placeholder = "Please enter a valid credit card number."
        creditCardNumberTextField.text = ""
        return nil
    }
    
    func checkAndGetCreditCardHolder() -> String? {
        if let creditCardHolder = creditCardCardholderNameTextField.text?.trimmingCharacters(in: .whitespaces) {
            if creditCardHolder.count > 0 {
                if creditCardHolder.contains(" ") && creditCardHolder.last != " " {
                    return creditCardHolder
                }
            }
        }
        
        creditCardCardholderNameTextField.layer.borderColor = UIColor.red.cgColor
        creditCardCardholderNameTextField.layer.borderWidth = 1.0
        creditCardCardholderNameTextField.placeholder = "Please enter your first and last name."
        creditCardCardholderNameTextField.text = ""
        return nil
    }
    
    func checkAndGetCreditCardCvv() -> Int? {
        if let cvvString = creditCardCvvTextField.text {
            if cvvString.count > 0 && cvvString.count < 6 {
                if let cvv = Int(cvvString) {
                    return cvv
                }
            }
        }
        
        creditCardCvvTextField.layer.borderColor = UIColor.red.cgColor
        creditCardCvvTextField.layer.borderWidth = 1.0
        creditCardCvvTextField.placeholder = "Please enter a valid cvv."
        creditCardCvvTextField.text = ""
        
        return nil
    }
    
    func checkAndGetUsername() -> String? {
        if let username = payPalUsernameTextField.text {
            if username.count > 0 {
                return username
            }
        }
        
        payPalUsernameTextField.layer.borderColor = UIColor.red.cgColor
        payPalUsernameTextField.layer.borderWidth = 1.0
        payPalUsernameTextField.placeholder = "Please enter a valid username."
        payPalUsernameTextField.text = ""
        
        return nil
    }
    
    func checkAndGetPassword() -> String? {
        if let password = payPalPasswordTextField.text {
            if password.count > 0 {
                return password
            }
        }
        
        payPalPasswordTextField.layer.borderColor = UIColor.red.cgColor
        payPalPasswordTextField.layer.borderWidth = 1.0
        payPalPasswordTextField.placeholder = "Please enter a valid password."
        payPalPasswordTextField.text = ""
        
        return nil
    }
}

//TextField Functions
extension PaymentDataTableViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedCharacters: CharacterSet?
        
        if textField == creditCardCardholderNameTextField {
            allowedCharacters = CharacterSet.letters
            allowedCharacters?.insert(charactersIn: " ")
        } else if textField == creditCardNumberTextField {
            allowedCharacters = CharacterSet.decimalDigits
        }
        
        let characterSet = CharacterSet(charactersIn: string)
        if let allowedCharacters = allowedCharacters {
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == creditCardNumberTextField {
            currentCreditCardNumber = ""
            creditCardNumberTextField.text = ""
            creditCardNumberTextField.placeholder = "Please enter credit number"
            creditCardNumberTextField.layer.borderWidth = 0.0
            creditCardNumberTextField.layer.borderColor = UIColor.clear.cgColor
        } else if textField == creditCardCardholderNameTextField {
            creditCardCardholderNameTextField.placeholder = "Please enter name"
            creditCardCardholderNameTextField.layer.borderWidth = 0.0
            creditCardCardholderNameTextField.layer.borderColor = UIColor.clear.cgColor
        } else if textField == creditCardCvvTextField {
            creditCardCvvTextField.placeholder = "Please enter cvv"
            creditCardCvvTextField.layer.borderColor = UIColor.clear.cgColor
            creditCardCvvTextField.layer.borderWidth = 1.0
            creditCardCvvTextField.text = ""
        } else if textField == payPalUsernameTextField {
            payPalUsernameTextField.placeholder = "Please enter username"
            payPalUsernameTextField.layer.borderWidth = 0.0
            payPalUsernameTextField.layer.borderColor = UIColor.clear.cgColor
        } else if textField == payPalPasswordTextField {
            payPalPasswordTextField.placeholder = "Please enter password"
            payPalPasswordTextField.layer.borderWidth = 0.0
            payPalPasswordTextField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldText = textField.text, textFieldText != "" && textFieldText != " " else {
            return
        }
        
        if textField == creditCardNumberTextField && textFieldText.count > 4 {
            currentCreditCardNumber = textFieldText
            
            var showPassword = ""
            let passwordArray = Array(currentCreditCardNumber)
            for _ in 0..<(passwordArray.count-4) {
                showPassword.append("*")
            }
            for i in (passwordArray.count - 4)...(passwordArray.count - 1) {
                showPassword.append(passwordArray[i])
            }
            textField.text = showPassword
        }
    }
}


