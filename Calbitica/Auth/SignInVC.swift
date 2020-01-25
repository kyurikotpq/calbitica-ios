//
//  SignInController.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInVC: UIViewController {
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "464289376160-gjc9oi5bk1s7e99tl7jqf440i442g00f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "464289376160-6in84jb9816ui0eea7uietultj9u9shl.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes = [
            "profile",
            "https://www.googleapis.com/auth/calendar.readonly",
            "https://www.googleapis.com/auth/calendar.events"
        ]
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
