//
//  CalbitDetailVC.swift
//  Calbitica
//
//  Created by Student on 30/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

protocol ReturnCalbitProtocol {
    func removeDeletedCalbit(calbit: CalbitForJZ)
    func updateCalbitCompletion(calbit: CalbitForJZ)
}

class CalbitDetailVC: UIViewController {
    var delegate: ReturnCalbitProtocol?
    
    static let today = Date()
    var calbit = CalbitForJZ(id: "", isAllDay: false, googleID: "",
                             calendarID: "", summary: "",
                             startDate: today, endDate: today,
                             location: nil,
                             description: nil,
                             completed: CalbitCompleted(status: false, date: ""),
                             reminders: [])
    
    // Outlets
    @IBOutlet weak var completeBtn: UIBarButtonItem!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateOrFromLbl: UILabel!
    @IBOutlet weak var timeOrToLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the views
        setupViews()
        setupCompleteBtn()
    }
    
    func setupViews() {
        titleLbl.text = calbit.summary
        let strings = DateUtil.buildToFromString(startDate: calbit.startDate, endDate: calbit.endDate)
        
        dateOrFromLbl.text = strings.0
        timeOrToLbl.text = strings.1
    }
    
    func setupCompleteBtn() {
        completeBtn.title = calbit.completed.status ? "Incomplete" : "Complete"
        completeBtn.tintColor = calbit.completed.status ? .white : CalbiticaColors.blue(1.0)
    }

    @IBAction func deleteBtnClicked(_ sender: UIBarButtonItem) {
        print("DELTE BUTTON CLICKED")
        // show action sheet to confirm the deletion,
        // and only delete if clicked on action sheet's delete
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // add actions to the menu
        let deleteAction = UIAlertAction(title: "Delete Event", style: .destructive, handler: {
            (UIAlertAction) -> Void in
            
            // Remove the local copy before popping
            self.delegate?.removeDeletedCalbit(calbit: self.calbit)
            self.navigationController?.popViewController(animated: true)
            
            // Meanwhile, remove from MongoDB
            Calbitica.deleteCalbit(self.calbit.id)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func completeBtnClicked(_ sender: UIBarButtonItem) {
        // change the text from complete to "incomplete"
        // and the color to white :)
        let isCompleted = !self.calbit.completed.status
        
        // Update the local & parent's copy
        // plus, change the button accordingly!
        self.calbit.completed.status = isCompleted
        self.delegate?.updateCalbitCompletion(calbit: self.calbit)
        
        setupCompleteBtn()
        Calbitica.completeCalbit(self.calbit.id, status: isCompleted)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editCalbitSegue") {
            // Editing event
            let navController = segue.destination as! UINavigationController
            let destinationController = navController.topViewController as! SaveCalbitVC
            
            destinationController.isNewCalbit = false
            destinationController.calbit = calbit
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
