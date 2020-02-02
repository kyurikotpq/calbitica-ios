//
//  AuthController.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthController {
    // Store JWT inside user preferences
    static func handleJWTClosure(jwt: String) {
        print(jwt)
        UserDefaults.standard.set(jwt, forKey: "jwt")
    }
    
    static func handleSignIn(code: String, user: GIDGoogleUser) {
        Calbitica.tokensFromAuthCode(code, closure: handleJWTClosure)
        
        // Store profile stuff inside user preferences
        UserDefaults.standard.set(user.profile.name, forKey: "displayName")
        UserDefaults.standard.set(user.profile.email, forKey: "email")
        
        if(user.profile.hasImage) {
            // returns the URL (URL object) of the user's profile image
            let pic = user.profile.imageURL(withDimension: UInt(150))
            UserDefaults.standard.set(pic, forKey: "thumbnail")
        }
        
        // Switch to the week view
        _ = Switcher.isSignedIn(true)
    }
}
