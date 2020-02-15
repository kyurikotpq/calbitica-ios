//
//  TabBarController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class TabBarTBC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell our UITabBarController subclass to handle its own delegate methods
        self.delegate = self
    }
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // Request events from Calbitica API (async)
        if viewController is UINavigationController {
            let navVC = viewController as! UINavigationController
            let rootVC = navVC.topViewController
            
            if rootVC is WeekVC {
                let vc = rootVC as! WeekVC
                vc.getCalbitsAndRefresh()
                
            } else if rootVC is AgendaTVC {
                let vc = rootVC as! AgendaTVC
                vc.getCalbitsAndRefresh()
            }
        }
        
    }
}
