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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get events
        getCalbitsAndRefresh()
        self.agendaTV.tableFooterView = UIView()
        
        // Scroll to today
        scrollToToday()
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
    
    // Every time a section title is displayed, run this function
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return calbitsForTV[section].0.ddMMMYYYY(false)
    }
    
    // Custom section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: tableView.frame.size.width, height: 18))
        let sectionHeaderText = calbitsForTV[section].0.ddMMMYYYY(false)
        label.text = sectionHeaderText
        
        let isToday = AgendaTVC.today.ddMMMYYYY(false) == sectionHeaderText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = isToday ? CalbiticaColors.blue(1.0) : .lightGray
        view.addSubview(label)
        
        view.backgroundColor = CalbiticaColors.darkGray(1.0)
        
        return view
    }
    
    // Populate each cell
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
        mapAndSortCalbitsForTV(calbits)
        
        DispatchQueue.main.async {
            // update the table view
            UIView.transition(with: self.agendaTV,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { () -> Void in
                                self.agendaTV.reloadData();
            }, completion: nil);
        }
    }
    
    func mapAndSortCalbitsForTV(_ calbits: [Calbit?]) {
        self.calbits = calbits
        let tempCalbitsForJZ = JZWeekViewHelper.getIntraEventsByDate(originalEvents: CalbiticaCalbitStore.calbitToJZ(calbits: calbits))
        
        // Sort the rows
        let sortedInnerCFJZ = tempCalbitsForJZ.mapValues { (calbits) -> [CalbitForJZ] in
            let sortedCFJZ = calbits.sorted(by: { (firstCalbit, secondCalbit) -> Bool in
                return firstCalbit.startDate < secondCalbit.startDate
            })
            
            return sortedCFJZ
        }
        
        // sort the sections
        let sortedOuterCFJZ: [(Date, [CalbitForJZ])] = sortedInnerCFJZ.sorted { (firstDate, secondDate) -> Bool in
            return (firstDate.key < secondDate.key)
        }
        self.calbitsForJZ = sortedInnerCFJZ
        self.calbitsForTV =  sortedOuterCFJZ
    }
    
    func scrollToToday() {
        if let todayIndex = calbitsForTV.firstIndex(where: { (arg0) -> Bool in
            let (date, calbits) = arg0
            return date.ddMMMYYYY(false) == AgendaTVC.today.ddMMMYYYY(false)
        }) {
            let indexPath = IndexPath(row: 0, section: todayIndex)
            self.agendaTV.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    // Actions
    @IBAction func todayBtnClicked(_ sender: UIBarButtonItem) {
        // Scroll to today's date
        scrollToToday()
    }
    
    // Refresh list of events
    @IBAction func refreshBtnClicked(_ sender: UIBarButtonItem) {
        getCalbitsAndRefresh()
    }
    
    // Handle on row tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calbit = calbitsForTV[indexPath.section].1[indexPath.row]
        self.selectedEvent = calbit
        
        self.performSegue(withIdentifier: "detailCalbitSegue", sender: self)
    }
    
    // Add actions for Complete and delete
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var calbit = self.calbitsForTV[indexPath.section].1[indexPath.row]
        let isCompleted = calbit.completed.status
        
        let actionText = isCompleted ? "Incomplete" : "Complete"
        let bgColor = isCompleted ? CalbiticaColors.darkGray(1.0) : CalbiticaColors.darkBlue(1.0)
        
        let completeAction = UITableViewRowAction(style: .normal, title: actionText) { (action, indexPath) -> Void in
            calbit.completed.status = !isCompleted
            self.completeCalbitFromActions(calbit: calbit)
            
            Calbitica.completeCalbit(calbit.id, status: !isCompleted)
        }
        completeAction.backgroundColor = bgColor
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) -> Void in
            let calbitsInTVSameDay = self.calbitsForTV[indexPath.section]
            let date = calbitsInTVSameDay.0
            let calbitToDelete = calbitsInTVSameDay.1[indexPath.row]
            
            self.removeOneDeletedCalbit(calbitToDelete)
            
            func deleteFinishClosure() {
                DispatchQueue.main.async {
                    self.getCalbitsAndRefresh()
                }
            }
            
            // remove from MongoDB
            Calbitica.deleteCalbit(calbitToDelete.id, closure: deleteFinishClosure)
        }
        return [deleteAction, completeAction]
    }
    
    func completeCalbitFromActions(calbit: CalbitForJZ) {
        if let index = calbits.firstIndex(where: { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }) {
            // update the local copy's completion status
            self.calbits[index]!.completed.status = calbit.completed.status
            
            // Reload the view!
            reloadTable(self.calbits)
        }
    }
    
    // Reload the table
    func getCalbitsAndRefresh() {
        CalbiticaCalendarStore.selfPopulate()
        CalbiticaCalbitStore.selfPopulate(closure: reloadTable)
    }
    
    func removeOneDeletedCalbit(_ calbit: CalbitForJZ) {
        self.calbits.removeAll { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }
        mapAndSortCalbitsForTV(self.calbits)
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
            destinationController.addDelegate = self as! ReturnCalbitProtocol
            //            destinationController.pressedDates = self.pressedDates
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
            let destinationController = segue.destination as! CalbitDetailVC
            
            destinationController.calbit = self.selectedEvent
            destinationController.delegate = self as! ReturnCalbitProtocol
            
            // Setup navbar (custom back button)
            let backBarButton = BackButtonItem("Agenda")
            self.navigationItem.backBarButtonItem = backBarButton
            
            // tabbar (hide)
            destinationController.hidesBottomBarWhenPushed = true
        }
    }
}
extension AgendaTVC : ReturnCalbitProtocol {
    // Post-segue things
    // If deleting from Detail view
    func removeDeletedCalbit(calbit: CalbitForJZ) {
        /**
         * Don't do anything, as the viewWillDisappear()
         * in CalbitDetailVC() will trigger saveCalbitFinished() >
         * getCalbitsAndRefresh() > ... > reloadTable()
         * and thus modifying the calbits data source
         * at this stage will cause a mismatch + errors
         */
    }
    
    func updateCalbitCompletion(calbit: CalbitForJZ) {
        /**
         * Don't do anything, as the viewWillDisappear()
         * in CalbitDetailVC() will trigger saveCalbitFinished() >
         * getCalbitsAndRefresh() > ... > reloadTable()
         * and thus modifying the calbits data source
         * at this stage will cause a mismatch + errors
        */
        
    }
    
    func saveCalbitFinished() {
        getCalbitsAndRefresh()
    }
    
}
