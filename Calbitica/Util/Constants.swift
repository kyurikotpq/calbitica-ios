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
    
    static let yellow = { (alpha: CGFloat) -> UIColor in
        // rgb(255, 190, 93)
        return UIColor(displayP3Red: 1.0, green: 190/255, blue: 93/255, alpha: alpha)
    }
    static let red = { (alpha: CGFloat) -> UIColor in
        // rgb(240, 92, 97)
        return UIColor(displayP3Red: 240/255, green: 92/255, blue: 97/255, alpha: alpha)
    }
}
