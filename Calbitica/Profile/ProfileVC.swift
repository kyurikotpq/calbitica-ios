//
//  ProfileVC.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileLevelType: UILabel!
    
    @IBOutlet weak var profileHP: UILabel!
    @IBOutlet weak var profileExp: UILabel!
    @IBOutlet weak var profileMana: UILabel!
    
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var expBar: UIProgressView!
    @IBOutlet weak var manaBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all the bar rounded, width and height
        healthBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        healthBar.layer.cornerRadius = 15.0
        healthBar.clipsToBounds = true
        
        expBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        expBar.layer.cornerRadius = 15.0
        expBar.clipsToBounds = true
        
        manaBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        manaBar.layer.cornerRadius = 15.0
        manaBar.clipsToBounds = true
        
        // Store JWT inside user preferences
        func handleProfileClosure(data: Profile) {
            
            DispatchQueue.main.async {
                self.profileName.text = data.profile["name"]
                
                let level = Int(data.stats.lvl)
                self.profileLevelType.text = "Level " + String(level) + " • " + String(data.stats.class)
                
                let HP = Int(data.stats.hp)
                let maxHP = Int(data.stats.maxHealth)
                let Exp = Int(data.stats.exp)
                let nextExp = Int(data.stats.toNextLevel)
                let Mana = Int(data.stats.mp)
                let maxMana = Int(data.stats.maxMP)
                
                // Set all the bar to the data value(needed in float)
                self.healthBar.progress = data.stats.hp / data.stats.maxHealth
                self.expBar.progress = data.stats.exp / data.stats.toNextLevel
                self.manaBar.progress = data.stats.mp / data.stats.maxMP
                
                self.profileHP.text = String(HP) + " / " + String(maxHP)
                self.profileExp.text = String(Exp) + " / " + String(nextExp)
                self.profileMana.text = String(Mana) + " / " + String(maxMana)
                
            }
        }
        
        Calbitica.getHProfile(closure: handleProfileClosure)

        // Do any additional setup after loading the view.
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
