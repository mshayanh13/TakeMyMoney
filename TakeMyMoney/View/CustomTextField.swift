//
//  CustomTextField.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/14/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customizeView()
    }
    
    func customizeView() {
        self.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        self.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.25)
        self.layer.cornerRadius = 5.0
        self.textAlignment = .center
    
        self.clipsToBounds = true
    }

}
