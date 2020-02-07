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
        Calbitica.changeCalSync(id: cal._id, sync: newSyncState, closure: handleCalSyncClosure)
        
        
    }
    
    // MARK: - Table view data source
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
