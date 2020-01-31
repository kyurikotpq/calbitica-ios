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
    static func isSignedIn(_ forceSignIn: Bool) -> Bool {
        // Get the JWT from UserDefaults
        let jwt = UserDefaults.standard.string(forKey: "jwt")
        let isSignedIn = forceSignIn || jwt != nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var rootVC : UIViewController?
        
        if (isSignedIn) {
            // Yes -> Navigate to Dashboard
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarTBC") as! TabBarTBC
            
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            // No -> Show Google Sign-In button
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signinVC") as! SignInVC
        }
        
        // Go to new destination controller
        appDelegate.window?.rootViewController = rootVC
        
        return isSignedIn
    }
    
}
