//
//  CalendarTVC.swift
//  Calbitica
//
//  Created by Student on 26/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class CalendarTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var calListTV: UITableView!
    
    // Source of data
    var calendars: [CalbiticaCalendar] = CalbiticaCalendarStore.getCalendars()
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in section
    // So far we only have one section, so return the number of calendars:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    // Every time a row is displayed, run this function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let cal = calendars[indexPath.row]
        cell.textLabel?.text = cal.summary
        cell.textLabel?.textColor = cal.sync
            ? CalbiticaColors.blue(1.0) : .white
        cell.accessoryType = cal.sync
            ? .checkmark : .none
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calListTV.tableFooterView = UIView()
    }
    
    // Handle on row tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newSyncState = false
        
        var cal = calendars[indexPath.row]
        newSyncState = !cal.sync
        
        // Update the table
        func handleCalSyncClosure(responseData: Data) {
            // Update the table and local variable if
            // change of status by API was successful :)
            calendars[indexPath.row].sync = newSyncState
            
            DispatchQueue.main.async {
                self.calListTV.reloadData()
            }
        }
        // Make the actual HTTP request to change the sync status
        Calbitica.changeCalSync(id: cal._id, sync: newSyncState, closure: handleCalSyncClosure)
        
    }
    
}
