//
//  HabiticaSettingsVC.swift
//  Calbitica
//
//  Created by Student on 29/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class HabiticaSettingsVC: UIViewController {
    @IBOutlet weak var userIDTF: DarkTextField!
    @IBOutlet weak var apiKeyTF: DarkTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set placeholder values
        userIDTF.setPlaceholderAndColor(string: "Enter Your Habitica User ID", color: UIColor.gray)
        apiKeyTF.setPlaceholderAndColor(string: "Enter Your Habitica API Key", color: UIColor.gray)
    }
    
    @IBAction func saveBtnClick(_ sender: UIBarButtonItem) {
        // Prep data for sending
        var data: [String: String] = [:];
        if let userID = userIDTF.text {
            if(userID != "") {
                data["hUserID"] = userID
            }
        }
        if let apiKey = apiKeyTF.text {
            if(apiKey != "") {
                data["apiKey"] = apiKey
            }
        }
        
        if(data.count == 0) {
            self.present(OkAlert.getAlert("No changes made."),
                    animated: true, completion: nil)
        } else {
            // Closure: What to do when there's a successful response?
            func handleJWTClosure(jwt: String) {
                AuthController.handleJWTClosure(jwt: jwt)
                
                // TODO: Add check mark to the non-empty TF(s)
                // Temp: Alert
                DispatchQueue.main.async {
                    self.present(OkAlert.getAlert("Settings saved successfully."),
                            animated: true, completion: nil)
                }
            }
            Calbitica.changeHabiticaAPIKey(data: data, closure: handleJWTClosure)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
