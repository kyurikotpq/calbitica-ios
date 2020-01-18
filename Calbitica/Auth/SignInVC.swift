//
//  SignInController.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
//import GoogleSignIn

class SignInVC: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("SOMEHOW IM SUPPOSED TO PRESENT SOMETHING?")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("SOMEHOW IM SUPPOSED TO dismiss SOMETHING?")
    }
 */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutPressed(_ sender: UIButton) {
       
        print("SHOULD SIGN OUT")
//        GIDSignIn.sharedInstance().signOut()
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
