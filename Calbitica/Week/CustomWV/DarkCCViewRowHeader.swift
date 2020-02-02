//
//  DarkCCViewRowHeader.swift
//  Calbitica
//
//  Created by Student on 26/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import JZCalendarWeekView

// Time labels
class DarkCCViewRowHeader : JZRowHeader {
    static let className = "DarkCCViewRowHeader"
    
    override func setupBasic() {
        // Change color
        super.setupBasic()
        backgroundColor = CalbiticaColors.darkGray(1.0)
    }
    
}
