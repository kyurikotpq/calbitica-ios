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
    
    @IBOutlet weak var questStatus: UILabel!
    @IBOutlet weak var questAccept: UIButton!
    @IBOutlet weak var questReject: UIButton!
    
    // To pass the partyID to the groupID
    var groupID: String!
    
    @IBOutlet weak var innStatus: UIButton!
    var sleepTrigger: Bool!
    
    // Only Run Once
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all the bar rounded, width and height
        healthBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        healthBar.layer.cornerRadius = 15.0
        healthBar.clipsToBounds = true
        healthBar.trackTintColor = CalbiticaColors.red(0.3)
        healthBar.progressTintColor = CalbiticaColors.red(1.0)
        
        expBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        expBar.layer.cornerRadius = 15.0
        expBar.clipsToBounds = true
        expBar.trackTintColor = CalbiticaColors.yellow(0.3)
        expBar.progressTintColor = CalbiticaColors.yellow(1.0)
        
        manaBar.transform = CGAffineTransform(scaleX: 1.5, y: 10)
        manaBar.layer.cornerRadius = 15.0
        manaBar.clipsToBounds = true
        manaBar.trackTintColor = CalbiticaColors.blue(0.3)
        manaBar.progressTintColor = CalbiticaColors.blue(1.0)
    }
    
    // Will re-run this function when clicked back to this page
    override func viewWillAppear(_ animated: Bool) {
        // Get Profile Data from database
        Calbitica.getHProfile(closure: handleProfileClosure)
    }
    
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
            
            self.groupID = data.party._id
            
            if (data.party.quest.RSVPNeeded) {
                self.questStatus.text = "You have not responded to the quest."
                
                self.questAccept.isHidden = false
                self.questReject.isHidden = false
            } else {
                self.questAccept.isHidden = true
                self.questReject.isHidden = true
                
                if (data.party.quest.key != nil) {
                    self.questStatus.text = "You have accepted the quest invitation."
                } else {
                    self.questStatus.text = "You have rejected the quest invitation."
                }
            }
            
            if(data.preferences.sleep == true) {
                self.innStatus.setTitle("Resume Damage", for: .normal)
                self.innStatus.setTitleColor(UIColor.white, for: .normal)
                self.innStatus.layer.backgroundColor = UIColor(red: 240/255, green: 92/255, blue: 97/225, alpha: 1).cgColor
                
                self.sleepTrigger = data.preferences.sleep
            } else {
                self.innStatus.setTitle("Pause Damage", for: .normal)
                self.innStatus.setTitleColor(UIColor.black, for: .normal)
                self.innStatus.layer.backgroundColor = UIColor(red: 68/255, green: 211/255, blue: 255/225, alpha: 1).cgColor
                
                self.sleepTrigger = data.preferences.sleep
            }
        }
    }
    func handleQuestClosure(data: QuestInfo) { }
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        self.questAccept.isHidden = true
        self.questReject.isHidden = true
        questStatus.text = "You have accepted the quest invitation."
        
        Calbitica.respondToQuest(accept: true, groupID: groupID, closure: handleQuestClosure)
    }
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        self.questAccept.isHidden = true
        self.questReject.isHidden = true
        questStatus.text = "You have rejected the quest invitation."
        
        Calbitica.respondToQuest(accept: false, groupID: groupID, closure: handleQuestClosure)
    }
    
    @IBAction func innDamage(_ sender: UIButton) {
        // Toggle the Inn to database
        func handleInnClosure(data: InnInfo) {
            DispatchQueue.main.async {
                if(data != nil && self.sleepTrigger != nil) {
                    if (self.sleepTrigger) {
                        guard self.presentedViewController == nil else {
                            return;
                        }
                        self.present(OkAlert.getAlert(data.message), animated: true, completion: nil)
                        self.sleepTrigger = data.sleep;
                        
                    } else {
                        guard self.presentedViewController == nil else {
                            return;
                        }
                        self.present(OkAlert.getAlert(data.message), animated: true, completion: nil)
                        self.sleepTrigger = data.sleep;
                        
                    }
                } else {
                    guard self.presentedViewController == nil else {
                        return;
                    }
                    self.present(OkAlert.getAlert("Ops you are not connected to database"), animated: true, completion: nil)
                }
            }
            // To accont for button spams
            Calbitica.getHProfile(closure: handleProfileClosure)
        }
        
        guard self.presentedViewController == nil else {
            return;
        }
        Calbitica.toggleSleep(closure: handleInnClosure)
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
