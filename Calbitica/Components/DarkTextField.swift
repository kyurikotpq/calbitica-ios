//
//  DarkTextField.swift
//  Calbitica
//
//  Created by Student on 30/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class DarkTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // change border and background color
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.darkGray.cgColor
        self.layer.borderColor = UIColor.darkGray.cgColor
        
        // Change text size
        self.font = self.font?.withSize(17.0)
        
        // Change text color and cursor color
        self.textColor = UIColor.white
        self.tintColor = UIColor.white
        
        // Add some padding
        let xPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height + 20))
        self.leftView = xPaddingView
        self.leftViewMode = UITextField.ViewMode.always
        self.rightView = xPaddingView
        self.rightViewMode = UITextField.ViewMode.always
    }

    // Change placeholder color
    func setPlaceholderAndColor(string: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
