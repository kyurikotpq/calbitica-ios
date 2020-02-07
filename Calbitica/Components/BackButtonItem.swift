//
//  BackButtonItem.swift
//  Calbitica
//
//  Created by Student on 7/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class BackButtonItem: UIBarButtonItem {
    init(_ title: String) {
        super.init()
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
