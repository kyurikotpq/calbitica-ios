//
//  Constants.swift
//  Calbitica
//
//  Created by Student on 26/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

//#44D3FF
class CalbiticaColors {
    static let blue = { (alpha: CGFloat) -> UIColor in
        return UIColor(displayP3Red: 68.0/255.0, green: 211.0/255.0, blue: 255.0/255.0, alpha: alpha)
    }
    static let darkBlue = { (alpha: CGFloat) -> UIColor in
        return UIColor(displayP3Red: 0/255.0, green: 103.0/255.0, blue: 174.0/255.0, alpha: alpha)
    }
    static let darkGray = { (alpha: CGFloat) -> UIColor in
        return UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.15, alpha: alpha)
    }
}
