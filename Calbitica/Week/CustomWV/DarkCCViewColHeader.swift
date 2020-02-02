//
//  DarkCCViewColHeader.swift
//  Calbitica
//
//  Created by Student on 26/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DarkCCViewColHeader : JZColumnHeader {
    static let className = "DarkCCViewColHeader"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CalbiticaColors.darkGray(1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
