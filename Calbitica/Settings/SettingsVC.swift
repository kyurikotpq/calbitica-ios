//
//  PartyController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsVC: UIViewController {
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var displayNameLbl: UILabel!
    @IBOutlet var habiticaSettings: UIButton!
    
    let spinnerAlert = SpinnerAlert.instance.alert
    var profileImgURL: URL? = nil, displayName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Google Profile
        profileImgURL = UserDefaults.standard.url(forKey: "thumbnail")!
        displayName = UserDefaults.standard.string(forKey:  "displayName")!
        
        displayNameLbl.text = displayName
        
        // Setup the UIImage for the profile picture
        if(profileImgURL != nil) {
            let data = try? Data(contentsOf: profileImgURL!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                profileImg.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sign out of the app
    @IBAction func logoutPressed(_ sender: UIButton) {
        // Ask for confirmation
        let confirmAlert = UIAlertController(title: "Logout of Calbitica",
                                             message: "Are you sure you want to logout?",
                                             preferredStyle: UIAlertController.Style.alert)
        
        // Build the actions
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            // show the spinner
            self.present(self.spinnerAlert, animated: true, completion: nil)
            
            // Clear user data
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            
            // Sign out from the GoogleAuth client
            GIDSignIn.sharedInstance().signOut()
            
            // dismiss the spinner alert
            self.spinnerAlert.dismiss(animated: true, completion: nil)
            
            // go back to sign in page
            let signInVC: UIViewController?
            signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signinVC") as! SignInVC
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = signInVC
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            // do nothing :)
        }))
        
        // display the alert
        present(confirmAlert, animated: true, completion: nil)
        
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
