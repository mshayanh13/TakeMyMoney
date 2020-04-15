//
//  CustomButton.swift
//  TakeMyMoney
//
//  Created by Mohammad Shayan on 4/14/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
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
        self.layer.cornerRadius = 12.0
    }

}
