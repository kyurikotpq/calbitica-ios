//
//  PartyController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var displayNameLbl: UILabel!
    @IBOutlet var habiticaSettings: UIButton!
    
    
    var profileImgURL: URL? = nil, displayName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImgURL = UserDefaults.standard.url(forKey: "thumbnail")!
        displayName = UserDefaults.standard.string(forKey:  "displayName")!
        
        displayNameLbl.text = displayName
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
