//
//  CalbitCell.swift
//  Calbitica
//
//  Created by Student on 1/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

// Controls the cell used for an event
class CalbitCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    var event: CalbitForJZ!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBasic()
    }
    
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
    }
    
    func incompleteCellStyle() {
        self.backgroundColor = CalbiticaColors.blue(1.0)
        borderView.backgroundColor = CalbiticaColors.darkBlue(1.0)
        titleLbl.textColor = UIColor.black
        locationLbl.textColor = UIColor.black
    }
    
    func completeCellStyle() {
        self.backgroundColor = .lightGray
        borderView.backgroundColor = UIColor.clear
        titleLbl.textColor = CalbiticaColors.darkGray(0.5)
        locationLbl.textColor = CalbiticaColors.darkGray(0.5)
    }
    
    func configureCell(event: CalbitForJZ) {
        self.event = event
        locationLbl.text = event.location
        titleLbl.text = event.summary
        
        // Conditional rendering of colors based on completion
        (event.completed.status)
            ? completeCellStyle()
            : incompleteCellStyle()
    }
    
}
