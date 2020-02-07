//
//  DarkCCViewCornerCell.swift
//  Calbitica
//
//  Created by Student on 2/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import JZCalendarWeekView

class DarkCCViewCornerCell : JZCornerHeader {
    static let className = "DarkCCViewCornerCell"
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = CalbiticaColors.darkGray(1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
