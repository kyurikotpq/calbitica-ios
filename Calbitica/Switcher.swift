//
//  Switcher.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    // Is the user signed in?
    static func isSignedIn() -> Bool {
        // Get the JWT from UserDefaults
        let jwt = UserDefaults.standard.string(forKey: "jwt")
        let isSignedIn = jwt != nil
        
        var rootVC : UIViewController?
        
        print(jwt)
        
        if (isSignedIn) {
            // Yes -> Navigate to Dashboard
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarTBC") as! TabBarTBC
        } else {
            // No -> Show Google Sign-In button
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signinVC") as! SignInVC
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
        return isSignedIn
    }
    
}
