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
    
    var pressLiao = false
    
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
    
    // Da static table
    @IBOutlet var staticTV: UITableView!
    
    // Event must haves
    @IBOutlet weak var eventTitleTF: DarkTextField!
    @IBOutlet weak var eventLocationTF: DarkTextField!
    
    // Start Date
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePickerCell: UITableViewCell!
    
    // End Date
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePickerCell: UITableViewCell!
    
    // Reminders
    @IBOutlet weak var reminderDateLbl: UILabel!
    @IBOutlet weak var reminderDatePickerCell: UITableViewCell!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderPresentSwitch: UISwitch!
    
    // Description
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
    
    // nice UI: show datepicker only on lbl tap
    func hidePickers() {
        startDatePickerCell.isHidden = true
        endDatePickerCell.isHidden = true
        reminderDatePickerCell.isHidden = true
        calendarPickerCell.isHidden = true
    }
    
    // Setup the "saving" action name
    // and the VC's title
    func setupNavbar() {
        rightNavbarBtn.title = (isNewCalbit) ? "Add" : "Done"
        customNavbarTitle.title = (isNewCalbit) ? "New Event" : "Edit Event"
    }
    
    // Setup the table
    func setupTableView() {
        // Setup Text Fields
        eventTitleTF.setPlaceholderAndColor(string: "Event Title", color: .gray)
        eventLocationTF.setPlaceholderAndColor(string: "Event Location", color: .gray)
        
        // Datepicker coloring (runtime values)
        startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        startDatePicker.setValue(false, forKeyPath: "highlightsToday")
        endDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        endDatePicker.setValue(false, forKeyPath: "highlightsToday")
        reminderDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        reminderDatePicker.setValue(false, forKeyPath: "highlightsToday")
        
    }
    
    // Populate the different fields
    func setData() {
        eventTitleTF.text = calbit.summary
        eventLocationTF.text = calbit.location
        
        let isAllDay = calbit.legitAllDay
        allDaySwitch.isOn = isAllDay
        startDateLbl.text = (isNewCalbit) ? "\(pressedDates.0.ddMMMYYYY(!isAllDay))" : calbit.startDate.ddMMMYYYY(!isAllDay)
        startDatePicker.date = (isNewCalbit) ? pressedDates.0 : calbit.startDate
        
        endDateLbl.text = (isNewCalbit) ? "\(pressedDates.1.ddMMMYYYY(!isAllDay))" : calbit.endDate.ddMMMYYYY(!isAllDay)
        endDatePicker.date = (isNewCalbit) ? pressedDates.1 : calbit.endDate
        
        // If there is at least one reminder, and we are not
        // creating a new Calbit, populate the reminders textLbl
        // as well as enable the switch
        if let reminders = calbit.reminders,
            let reminderDate = reminders.first,
            let reminderDateStr = reminderDate,
            reminders.count > 0,
            (!isNewCalbit) {
            reminderDateLbl.text = DateUtil.toDate(str: reminderDateStr)!.ddMMMYYYY(true)
            reminderPresentSwitch.isOn = true
        } else {
            reminderDateLbl.text = "Never"
            reminderPresentSwitch.isOn = false
        }
        
        descriptionTV.text = calbit.calbitDescription
    }
    
    // Setup the calendar picker
    func setupCalendarPicker() {
        self.calendarPicker.delegate = self
        self.calendarPicker.dataSource = self
        
        let calendar = CalbiticaCalendarStore.getFromGoogleID(calbit.calendarID)
        let summary = calendar.0.summary
        calendarLbl.text = summary
        calendarPicker.selectRow(calendar.1, inComponent: 0, animated: true)
    }
    // Number of columns in Calendar Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // Number of options (rows) in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendars.count
    }
    // Make it white text (default is light gray)
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: calendars[row].summary, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    // Change the options (rows) de text
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calendarLbl.text = calendars[row].summary
    }
    
    // Navigation bar button actions
    // Cancel/Exit the current VC
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // dismiss yourself
    }
    
    // Save the new/current calbit
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if (pressLiao) { return }
        
        let isAllDay =  allDaySwitch.isOn
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        guard (eventTitleTF.text != nil && eventTitleTF.text != ""),
            self.presentedViewController == nil else {
                self.present(OkAlert.getAlert("Please fill in the event title"), animated: true)
                return
        }
        
        guard (startDate < endDate) ||
            ((startDate == endDate) && isAllDay),
            self.presentedViewController == nil else {
                self.present(OkAlert.getAlert("Start date and time must be before end date and time"),
                             animated: true)
                return
        }
        
        pressLiao = true
        
        let row = calendarPicker.selectedRow(inComponent: 0)
        let cal = calendars[row]
        let calendarID = cal.googleID
        
        var data: [String: Any?] = [
            "title": eventTitleTF.text,
            "calendarID": calendarID,
            "allDay": isAllDay,
            "start": isAllDay ? startDate.otherFormats("yyyy-MM-dd") : startDate.toISOString(),
            "end": isAllDay ? endDate.otherFormats("yyyy-MM-dd") : endDate.toISOString(),
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
        calbit.startDate = startDate
        calbit.endDate = endDate
        
        // Add reminder date time if any
        // For now we will only support one reminder.
        // sorry cher, forgive us ><||
        if(reminderPresentSwitch.isOn) {
            data["reminders"] = reminderDatePicker.date.toISOString()
        }
        
        if(isNewCalbit) {
            func httpClosure(data: Data) {
                self.addDelegate?.saveCalbitFinished()
                self.dismiss(animated: true, completion: nil)
            }
            Calbitica.createCalbit(data: data, closure: httpClosure)
        } else {
            data["googleID"] = calbit.googleID
            
            func httpClosure(data: Data) {
                self.updateDelegate?.updateCalbit(newCalbit: calbit)
                self.dismiss(animated: true, completion: nil)
            }
            Calbitica.updateCalbit(self.calbit.id, data: data, closure: httpClosure)
        }
        
    }
    
    // Hide the picker and change the text label if switch is on
    @IBAction func onReminderPresentSwitchChanged(_ sender: Any) {
        let hasReminder = reminderPresentSwitch.isOn
        reminderDateLbl.text = hasReminder ? reminderDatePicker.date.ddMMMYYYY(true) : "Never"
        
        reminderDatePickerCell.isHidden = true;
        tableView.reloadData()
    }
    
    // Show/hide times based on whether it's all-day
    @IBAction func onAllDaySwitchChanged(_ sender: Any) {
        let startDate = startDatePicker.date.ddMMMYYYY(!allDaySwitch.isOn),
            endDate = endDatePicker.date.ddMMMYYYY(!allDaySwitch.isOn)
        startDateLbl.text = startDate
        endDateLbl.text = endDate
    }
    
    // Update the text labels if there are changes in the values
    // of the datepickers
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date.ddMMMYYYY(!allDaySwitch.isOn)
        if(sender.isDescendant(of: startDatePickerCell)) {
            startDateLbl.text = date
        } else if(sender.isDescendant(of: endDatePickerCell)) {
            endDateLbl.text = date
        } else if(sender.isDescendant(of: reminderDatePickerCell)) {
            reminderDateLbl.text = date
        }
    }
    
    // "Listen" to prevoius sibling tap
    // to hide/show the correct picker row later on
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
        if(indexPath.row == 2 && indexPath.section == 2
            && reminderPresentSwitch.isOn) {
            reminderDatePickerCell.isHidden = !reminderDatePickerCell.isHidden
            calendarPickerCell.isHidden = true
            startDatePickerCell.isHidden = true
            endDatePickerCell.isHidden = true
            needsReload = true
        }
        
        // Reload the table to effect any changes in
        // hiding and showing of rows
        if(needsReload) {
            tableView.reloadData()
        }
    }
    
    // Actual hiding/showing of table rows
    // through the manipulation of row height
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
    
}
