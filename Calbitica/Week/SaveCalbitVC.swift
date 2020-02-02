//
//  AddCalbitVC.swift
//  Calbitica
//
//  Created by Student on 25/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class SaveCalbitVC: UITableViewController {
    static let today = Date()
    var isNewCalbit = true
    var pressedDates = (today, today)
    var calbit = CalbitForJZ(id: "", isAllDay: false, googleID: "",
                             calendarID: "", summary: "",
                             startDate: today, endDate: today,
                             location: nil,
                             description: nil,
                             completed: CalbitCompleted(status: false, date: ""),
                             reminders: [])
    
    // Outlets
    @IBOutlet weak var customNavbarTitle: UINavigationItem!
    @IBOutlet weak var rightNavbarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupTableView()
    }
    
    func setupNavbar() {
        rightNavbarBtn.title = (isNewCalbit) ? "Add" : "Done"
        customNavbarTitle.title = (isNewCalbit) ? "New Event" : "Edit Event"
    }
    
    func setupTableView() {
        // Setup Text Fields
        
    }
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // dismiss yourself
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        //        Calbitica.createCalbit()
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
