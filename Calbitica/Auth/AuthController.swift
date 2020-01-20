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
    static func handleSignIn(code: String, user: GIDGoogleUser) {
        // Store JWT inside user preferences
        func handleJWTClosure(jwt: String) {
            UserDefaults.standard.set(jwt, forKey: "jwt")
        }
        Calbitica.tokensFromAuthCode(code, closure: handleJWTClosure)
        
        // Store profile stuff inside user preferences
        UserDefaults.standard.set(user.profile.name, forKey: "displayName")
        
        if(user.profile.hasImage) {
            // returns the URL (URL object) of the user's profile image
            let pic = user.profile.imageURL(withDimension: UInt(150))
            UserDefaults.standard.set(pic, forKey: "thumbnail")
        }
    }
}
