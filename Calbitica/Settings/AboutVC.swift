//
//  AboutVC.swift
//  Calbitica
//
//  Created by user on 2/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Make actual phone call
    @IBAction func hotlineInfo(_ sender: UIButton) {
        if let phoneCallURL:URL = URL(string: "tel:\(61157894)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Call Calbitica", message: "Are you sure you want to call \n\(61157894)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.open(phoneCallURL, completionHandler: nil)
                })
                let noPressed = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Open email app
    @IBAction func siteInfo(_ sender: Any) {
        let email = "calbitica@support.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
