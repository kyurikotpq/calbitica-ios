//
//  DarkCCViewAllDayHeader.swift
//  Calbitica
//
//  Created by Student on 2/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import JZCalendarWeekView

class DarkCCViewAllDayCorner : JZAllDayCorner {
    static let className = "DarkCCViewAllDayCorner"
    
    override func setupUI() {
        super.setupUI()
        
        self.backgroundColor = CalbiticaColors.darkGray(1.0)
        lblTitle.textColor = .lightGray
    }
}

class DarkCCViewAllDayHeaderBackground : JZAllDayHeaderBackground {
    static let className = "DarkCCViewAllDayHeaderBackground"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
