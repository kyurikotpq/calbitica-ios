//
//  AddCalbitVC.swift
//  Calbitica
//
//  Created by Student on 25/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit

class SaveCalbitVC: UITableViewController,
UIPickerViewDelegate, UIPickerViewDataSource {
    var updateDelegate: UpdateCalbitDetailProtocol?
    var addDelegate: ReturnCalbitProtocol?
    
    static let today = Date()
    var isNewCalbit = true
    var pressedDates = (today, today)
    
    let calendars = CalbiticaCalendarStore.getCalendars()
    var calbit = CalbitForJZ(id: "", isAllDay: false,
                             legitAllDay: false, googleID: "",
                             calendarID: "", summary: "",
                             startDate: today, endDate: today,
                             location: nil,
                             description: nil,
                             completed: CalbitCompleted(status: false, date: ""),
                             reminders: [])
    
    let startDatePickerIdentifier = "startDatePickerCell",
    endDatePickerIdentifier = "endDatePickerCell"
    
    // Outlets
    @IBOutlet weak var customNavbarTitle: UINavigationItem!
    @IBOutlet weak var rightNavbarBtn: UIBarButtonItem!
    
    @IBOutlet var staticTV: UITableView!
    
    @IBOutlet weak var eventTitleTF: DarkTextField!
    @IBOutlet weak var eventLocationTF: DarkTextField!
    
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePickerCell: UITableViewCell!
    
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePickerCell: UITableViewCell!
    
    @IBOutlet weak var reminderDateLbl: UILabel!
    @IBOutlet weak var reminderDatePickerCell: UITableViewCell!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTV: UITextView!
    
    // Calendar picker
    @IBOutlet weak var calendarLbl: UILabel!
    @IBOutlet weak var calendarPickerCell: UITableViewCell!
    @IBOutlet weak var calendarPicker: UIPickerView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hidePickers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupTableView()
        setData()
        setupCalendarPicker()
    }
    
    func hidePickers() {
        // nice UI: show datepicker only on lbl tap
        startDatePickerCell.isHidden = true
        endDatePickerCell.isHidden = true
        reminderDatePickerCell.isHidden = true
        calendarPickerCell.isHidden = true
    }
    
    func setupNavbar() {
        rightNavbarBtn.title = (isNewCalbit) ? "Add" : "Done"
        customNavbarTitle.title = (isNewCalbit) ? "New Event" : "Edit Event"
    }
    
    func setupTableView() {
        // Setup Text Fields
        eventTitleTF.setPlaceholderAndColor(string: "Event Title", color: .gray)
        eventLocationTF.setPlaceholderAndColor(string: "Event Location", color: .gray)
        
        // Datepicker coloring (runtime valeus)
        startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        startDatePicker.setValue(false, forKeyPath: "highlightsToday")
        endDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        endDatePicker.setValue(false, forKeyPath: "highlightsToday")
        reminderDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        reminderDatePicker.setValue(false, forKeyPath: "highlightsToday")
        
    }
    
    func setData() {
        eventTitleTF.text = calbit.summary
        eventLocationTF.text = calbit.location
        
        allDaySwitch.isOn = calbit.legitAllDay
        startDateLbl.text = (isNewCalbit) ? "\(pressedDates.0.ddMMMYYYY(true))" : calbit.startDate.ddMMMYYYY(true)
        startDatePicker.date = (isNewCalbit) ? pressedDates.0 : calbit.startDate
        
        endDateLbl.text = (isNewCalbit) ? "\(pressedDates.1.ddMMMYYYY(true))" : calbit.endDate.ddMMMYYYY(true)
        endDatePicker.date = (isNewCalbit) ? pressedDates.1 : calbit.endDate
        
        if let reminders = calbit.reminders,
            reminders.count > 0,
            (!isNewCalbit) {
            reminderDateLbl.text = DateUtil.toDate(str: (calbit.reminders?.first)!)!.ddMMMYYYY(true)
        } else {
            reminderDateLbl.text = "Never"
        }
        
        descriptionTV.text = calbit.calbitDescription
    }
    
    
    func setupCalendarPicker() {
        self.calendarPicker.delegate = self
        self.calendarPicker.dataSource = self
        
        let calendar = CalbiticaCalendarStore.getFromGoogleID(calbit.calendarID)
        let summary = calendar.0.summary
        calendarLbl.text = summary
        calendarPicker.selectRow(calendar.1, inComponent: 0, animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendars.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: calendars[row].summary, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calendarLbl.text = calendars[row].summary
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // dismiss yourself
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if(eventTitleTF.text != nil && eventTitleTF.text != "") {
            let row = calendarPicker.selectedRow(inComponent: 0)
            let cal = calendars[row]
            let calendarID = cal.googleID
            
            var data: [String: Any] = [
                "title": eventTitleTF.text,
                "calendarID": calendarID,
                "allDay": allDaySwitch.isOn,
                "start": startDatePicker.date.toISOString(),
                "end": endDatePicker.date.toISOString(),
                "isDump": false,
                "display": cal.sync
            ]
            if(descriptionTV.text != "") {
                data["description"] = descriptionTV.text
            }
            
            if(eventLocationTF.text != "") {
                data["location"] = eventLocationTF.text
            }
            
            calbit.summary = eventTitleTF.text!
            calbit.calendarID = calendarID
            calbit.isAllDay = allDaySwitch.isOn
            calbit.startDate = startDatePicker.date
            calbit.endDate = endDatePicker.date
            
            print(data)
            if(isNewCalbit) {
                func httpClosure(data: Data) {
                    print("WE MADE A POST REQUEST LIAO")
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    
                    print(json);
                    self.addDelegate?.addCalbitFinished()
                    self.dismiss(animated: true, completion: nil)
                }
                Calbitica.createCalbit(data: data, closure: httpClosure)
            } else {
                data["googleID"] = calbit.googleID
                
                func httpClosure(data: Data) {
                    print("WE MADE A PUT REQUEST LIAO")
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    
                    print(json);
                    self.updateDelegate?.updateCalbit(newCalbit: calbit)
                    self.dismiss(animated: true, completion: nil)
                }
                Calbitica.updateCalbit(self.calbit.id, data: data, closure: httpClosure)
            }
            
            
        } else {
            self.present(OkAlert.getAlert("Please fill in the event title"), animated: true)
        }
    }
    
    // TODO:
    // Hide start and end dates if switch is on
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date.ddMMMYYYY(true)
        if(sender.isDescendant(of: startDatePickerCell)) {
            startDateLbl.text = date
        } else if(sender.isDescendant(of: endDatePickerCell)) {
            endDateLbl.text = date
        } else if(sender.isDescendant(of: reminderDatePickerCell)) {
            reminderDateLbl.text = date
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var needsReload = false
        
        // Start Date Picker
        if(indexPath.row == 1 && indexPath.section == 1) {
            startDatePickerCell.isHidden = !startDatePickerCell.isHidden
            calendarPickerCell.isHidden = true
            endDatePickerCell.isHidden = true
            reminderDatePickerCell.isHidden = true
            needsReload = true
        }
        
        // End Date Picker
        if(indexPath.row == 3 && indexPath.section == 1) {
            endDatePickerCell.isHidden = !endDatePickerCell.isHidden
            calendarPickerCell.isHidden = true
            startDatePickerCell.isHidden = true
            reminderDatePickerCell.isHidden = true
            needsReload = true
        }
        
        // calendarPicker
        if(indexPath.row == 0 && indexPath.section == 2) {
            calendarPickerCell.isHidden = !calendarPickerCell.isHidden
            reminderDatePickerCell.isHidden = true
            startDatePickerCell.isHidden = true
            endDatePickerCell.isHidden = true
            needsReload = true
        }
        // reminderDatePicker
        if(indexPath.row == 2 && indexPath.section == 2) {
            reminderDatePickerCell.isHidden = !reminderDatePickerCell.isHidden
            calendarPickerCell.isHidden = true
            startDatePickerCell.isHidden = true
            endDatePickerCell.isHidden = true
            needsReload = true
        }
        
        if(needsReload) {
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Start DatePicker
        if(indexPath.row == 2 && indexPath.section == 1) {
            return (startDatePickerCell.isHidden) ? 0 : 150
        }
        
        // End Datepicker
        if(indexPath.row == 4 && indexPath.section == 1) {
            return (endDatePickerCell.isHidden) ? 0 : 150
        }
        
        // Calendar Picker
        if(indexPath.row == 1 && indexPath.section == 2) {
            return (calendarPickerCell.isHidden) ? 0 : 100
        }
        
        
        // Reminder DatePicker
        if(indexPath.row == 3 && indexPath.section == 2) {
            return (reminderDatePickerCell.isHidden) ? 0 : 150
        }
        
        // Description
        if(indexPath.row == 4 && indexPath.section == 2) {
            return 100
        }
        
        return 50
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
