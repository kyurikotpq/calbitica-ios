//
//  AgendaTVCell.swift
//  Calbitica
//
//  Created by Student on 5/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class AgendaTVCell: UITableViewCell {
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
