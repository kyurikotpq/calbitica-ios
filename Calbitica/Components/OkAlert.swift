//
//  OkAlert.swift
//  Calbitica
//
//  Created by Student on 29/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

// Show a message alert with an OK button for dismissal
class OkAlert {
    private static var instance = OkAlert()
    
    var alert: UIAlertController
    
    private init() {
        // Ask for confirmation
        alert = UIAlertController(title: "",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        
        // Build the actions
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
            (action: UIAlertAction!) in
            // do nothing :)
        }))
    }
        
    public static func getAlert(_ title: String) -> UIAlertController {
        instance.alert.title = title
        return instance.alert
    }
}
