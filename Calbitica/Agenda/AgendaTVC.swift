//
//  AgendaController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class AgendaTVC: UITableViewController {
    @IBOutlet weak var agendaTV: UITableView!
    
    // variables
    static var today = Date()
    
    var selectedEvent = CalbitForJZ(id: "", isAllDay: false,
                                    legitAllDay: false, googleID: "",
                                    calendarID: "", summary: "",
                                    startDate: today, endDate: today,
                                    location: nil,
                                    description: nil,
                                    completed: CalbitCompleted(status: false, date: ""),
                                    reminders: [])
    var calbits: [Calbit?] = CalbiticaCalbitStore.getCalbits()
    var calbitsForJZ: [Date : [CalbitForJZ]] = [:]
    var calbitsForTV: [(Date, [CalbitForJZ])] = []
    
    let cellID = "AgendaCell"
    let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCalbitsAndRefresh()
        self.agendaTV.tableFooterView = UIView()
        
        // Long press to complete!
        self.agendaTV.addGestureRecognizer(longPressGR)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // number of sections - return number of days in the store
    // to be honest, we can get the JZWeekViewHelper to help us
    override func numberOfSections(in tableView: UITableView) -> Int {
        return calbitsForJZ.count
    }
    
    // Number of rows in section
    // So far we only have one section, so return the number of calendars:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calbitsForTV[section].1.count
    }
    
    // Every time a section is displayed, run this function
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return calbitsForTV[section].0.ddMMMYYYY(false)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AgendaTVCell
        
        let calbit = calbitsForTV[indexPath.section].1[indexPath.row]
        cell.titleLbl?.text = calbit.summary
        cell.startTimeLbl?.text = calbit.startDate.otherFormats("HH:mm")
        cell.endTimeLbl?.text = calbit.endDate.otherFormats("HH:mm")
        cell.divider?.backgroundColor = calbit.completed.status
            ? .lightGray : CalbiticaColors.blue(1.0)
        cell.accessoryType = calbit.completed.status
            ? .checkmark : .none
        
        return cell
    }
    
    func reloadTable(_ calbits: [Calbit?]) {
        self.calbits = calbits
        self.calbitsForJZ = JZWeekViewHelper.getIntraEventsByDate(originalEvents: CalbiticaCalbitStore.calbitToJZ(calbits: calbits))
        self.calbitsForTV =  self.calbitsForJZ.map { ($0.key, $0.value) }
        
        DispatchQueue.main.async {
            self.agendaTV.reloadData();
        }
    }
    
    
    // Actions
    @IBAction func todayBtnClicked(_ sender: UIBarButtonItem) {
        // Scroll to today's datee
    }
    
    @IBAction func refreshBtnClicked(_ sender: UIBarButtonItem) {
        getCalbitsAndRefresh()
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt: IndexPath) -> String? {
        let indexPath = titleForDeleteConfirmationButtonForRowAt
        let calbit = calbitsForTV[indexPath.section].1[indexPath.row]
        return "Are you sure you want to delete \(calbit.summary)?"
    }
    
    // Handle on row tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calbit = calbitsForTV[indexPath.section].1[indexPath.row]
        self.selectedEvent = calbit
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if longPressGR.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGR.location(in: agendaTV)
            if let indexPath = agendaTV.indexPathForRow(at: touchPoint) {
                
                let calbit = calbitsForTV[indexPath.section].1[indexPath.row]
                calbit.completed.status = !calbit.completed.status
                
                // can you do this? i don't think so
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    // Add actions for Edit and delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) -> Void in
            let calbit = self.calbitsForTV[indexPath.section].1[indexPath.row]
            self.selectedEvent = calbit
            self.performSegue(withIdentifier: "editCalbitSegue", sender: self)
        }
        editAction.backgroundColor = CalbiticaColors.darkBlue(1.0)
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) -> Void in
            let calbitInTV = self.calbitsForTV[indexPath.section]
            
            // Remove and return the CalbitForJZ
            if let calbitForJZ = self.calbitsForJZ[calbitInTV.0]?.remove(at: indexPath.row) {
                // remove from MongoDB
                Calbitica.deleteCalbit(calbitForJZ.id)
                
                // remove from calbits too
                self.calbits.removeAll { (c: Calbit?) -> Bool in
                    return c?._id == calbitForJZ.id
                }
                
                // update the table view
                tableView.deleteRows(at: [indexPath], with: .top)
                
            }
        }
        return [deleteAction, editAction]
    }
    
    
    func getCalbitsAndRefresh() {
        CalbiticaCalendarStore.selfPopulate()
        CalbiticaCalbitStore.selfPopulate(closure: reloadTable)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addCalbitSegue") {
            // Adding new event
            let navController = segue.destination as! UINavigationController
            
            // We only have one VC for this navigation controller, so this works I guess...
            let destinationController = navController.topViewController as! SaveCalbitVC
            destinationController.isNewCalbit = true
            //            destinationController.pressedDates = self.pressedDates
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
            let destinationController = segue.destination as! CalbitDetailVC
            destinationController.calbit = self.selectedEvent
            
            print("selected event:")
            print(self.selectedEvent.summary)
            destinationController.delegate = self as! ReturnCalbitProtocol
            
            // Setup navbar (custom back button)
            let backBarButton = BackButtonItem("Agenda")
            self.navigationItem.backBarButtonItem = backBarButton
            
            print("my back button should be there??")
            // tabbar (hide)
            destinationController.hidesBottomBarWhenPushed = true
        } else if(segue.identifier == "editCalbitSegue") {
            // Editing event
            let navController = segue.destination as! UINavigationController
            let destinationController = navController.topViewController as! SaveCalbitVC
            
            destinationController.updateDelegate = self as! UpdateCalbitDetailProtocol
            destinationController.isNewCalbit = false
            destinationController.calbit = self.selectedEvent
        }
    }
}
extension AgendaTVC : ReturnCalbitProtocol {
    // Post-segue things
    // If deleting from Detail view
    func removeDeletedCalbit(calbit: CalbitForJZ) {
        self.calbits.removeAll { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }
        reloadTable(self.calbits)
    }
    
    func updateCalbitCompletion(calbit: CalbitForJZ) {
        if let index = calbits.firstIndex(where: { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }) {
            // update the local copy's completion status
            self.calbits[index]!.completed.status = calbit.completed.status
            
            // Reload the view!
            reloadTable(self.calbits)
        }
    }
    
    func addCalbitFinished() {
        getCalbitsAndRefresh()
    }
    
}

extension AgendaTVC : UpdateCalbitDetailProtocol {
    func updateCalbit(newCalbit: CalbitForJZ) {
        // update the local copy's completion status
        // and title - the various stuffs visible
        // in the detail view
        
        // Populate the views
        if let index = calbits.firstIndex(where: { (c: Calbit?) -> Bool in
            return c?._id == newCalbit.id
        }) {
            // update the local copy's completion status
            self.calbits[index]!.completed.status = newCalbit.completed.status
            
            // Reload the view!
            
            DispatchQueue.main.async {
                self.reloadTable(self.calbits)
            }
        }
    }
    
    
}
