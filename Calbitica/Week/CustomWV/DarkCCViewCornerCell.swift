//
//  DarkCCViewCornerCell.swift
//  Calbitica
//
//  Created by Student on 2/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import JZCalendarWeekView

// This is the cell between time labels (row header)
// & day labels (col header)
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
