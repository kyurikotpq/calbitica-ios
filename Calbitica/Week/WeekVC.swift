//
//  WeekController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class WeekVC: UIViewController, ReturnCalbitProtocol {
    // Our Custom week view
    @IBOutlet weak var calendarWeekView: CCView!
    
    // variables
    static var today = Date()
    
    var calbits: [Calbit?] = []
    var pressedDates: (Date, Date) = (today, today)
    var selectedEvent = CalbitForJZ(id: "", isAllDay: false, googleID: "",
                                    calendarID: "", summary: "",
                                    startDate: today, endDate: today,
                                    location: nil,
                                    description: nil,
                                    completed: CalbitCompleted(status: false, date: ""),
                                    reminders: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // setup calendar
        calendarWeekView.collectionView.tintColor = .white
        calendarWeekView.collectionView.backgroundColor = .black
        
        calendarWeekView.setupCalendar(numOfDays: 7,
                                       setDate: WeekVC.today,
                                       allEvents:
            JZWeekViewHelper.getIntraEventsByDate(originalEvents: []),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Sunday)
        calendarWeekView.baseDelegate = self
        
        calendarWeekView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnCCView)))
        
        // setup navbar
        setupNavbar()
        
        // Request events from Calbitica API (async)
        getCalbitsAndRefresh()
        print(calendarWeekView.numberOfSections)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavbar() {
        // back button text
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
        //        self.navigationItem.backBarButtonItem?.image = nil
        //        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        // Set navigation bar title to this week's date
        updateNavbarTitle()
    }
    
    func updateNavbarTitle() {
        var datesInWeek: [Date] = calendarWeekView.getDatesInCurrentPage(isScrolling: false)
        let firstDate = datesInWeek[0]
        let lastDate = datesInWeek.last!
        self.navigationItem.title = DateUtil.buildNavbarTitle(firstDate: firstDate, lastDate: lastDate)
    }
    
    // Handle navigation bar actions
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        print("refresh btn pressed")
        getCalbitsAndRefresh()
    }
    @IBAction func todayBtnPressed(_ sender: UIBarButtonItem) {
        // You need both of these functions if you want to jump
        // to today, but prevent today from being the first day of the week
        calendarWeekView.updateWeekView(to: WeekVC.today)
        calendarWeekView.updateFirstDayOfWeek(setDate: WeekVC.today, firstDayOfWeek: .Sunday)
    }
    
    @objc func tapOnCCView(sender: UITapGestureRecognizer){
        if let indexPath = calendarWeekView.collectionView?.indexPathForItem(at: sender.location(in: calendarWeekView.collectionView)) {
            if let selectedEvent = calendarWeekView.getCurrentEvent(with: indexPath) as? CalbitForJZ {
                self.selectedEvent = selectedEvent
                self.performSegue(withIdentifier: "detailCalbitSegue", sender: self)
                print(indexPath)
                print("you can do something with the cell or index path here")
            }
        } else if(!sender.cancelsTouchesInView) {
            var date = calendarWeekView.getDateForPoint(sender.location(in: calendarWeekView.collectionView))
            
            // Round of dates to the nearest 30mins
            // and calculate 30mins from there
            self.pressedDates = DateUtil.calculate30Mins(date: date, round: true)
            self.performSegue(withIdentifier: "addCalbitSegue", sender: self)
        }
    }
    
    // Makes the HTTP request if the JWT in UserData exists
    func getCalbitsAndRefresh() {
        // Check if the JWT is ready
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"),
            jwt != ""
            else {
                // If the jwt is not ready, don't make a request.
                // wait for a while, then call this function
                // and attempt to make the request again.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.getCalbitsAndRefresh()
                }
                
                // Exit the getCalbitsAndRefresh function
                return
        }
        
        // Handle response from calbits
        // and render events as appropriate
        func handleCalbits(_ calbitResponse: CalbiticaCalbits) -> Void {
            calbits.removeAll()
            calbits = calbitResponse.data // calbits is gobal var
            refreshWeekView()
        }
        // JWT is ready - lets make the HTTP Request
        Calbitica.getCalbits(closure: handleCalbits)
    }
    
    // re-load the week view
    func refreshWeekView() {
        let calbitsForJZ = JZWeekViewHelper.getIntraEventsByDate(originalEvents: calbitToJZ())
        calendarWeekView.forceReload(reloadEvents: calbitsForJZ)
    }
    
    // Helper function: convert calbit to calbit for JZ
    func calbitToJZ() -> [CalbitForJZ] {
        return calbits.map({ (Calbit) -> CalbitForJZ in
            let start = Calbit!.allDay ? Calbit!.start["date"] : Calbit?.start["dateTime"]
            let startDate = DateUtil.toDate(str: start!)
            
            let end = Calbit!.allDay ? Calbit!.end["date"] : Calbit!.end["dateTime"]
            let endDate = DateUtil.toDate(str: end!)
            
            // Transform into a JZ-compliant calbit!
            return CalbitForJZ(id: Calbit!._id, isAllDay: Calbit!.allDay, googleID: Calbit!.googleID,
                               calendarID: Calbit!.calendarID, summary: Calbit!.summary,
                               startDate: startDate!, endDate: endDate!,
                               location: Calbit!.location ?? nil,
                               description: Calbit!.description ?? nil,
                               completed: Calbit!.completed, reminders: Calbit!.reminders)
        })
    }
    
    // Remove deleted calbit from local array
    func removeDeletedCalbit(calbit: CalbitForJZ) {
        calbits.removeAll { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }
        refreshWeekView()
    }
    
    func updateCalbitCompletion(calbit: CalbitForJZ) {
        if let index = calbits.firstIndex(where: { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }) {
            // update the local copy's completion status
            calbits[index]!.completed.status = calbit.completed.status
            
            // Reload the view!
            refreshWeekView()
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "addCalbitSegue") {
            // Adding new event
            let navController = segue.destination as! UINavigationController
            
            // We only have one VC for this navigation controller, so this works I guess...
            let destinationController = navController.topViewController as! SaveCalbitVC
            destinationController.isNewCalbit = true
            destinationController.pressedDates = self.pressedDates
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
            self.pressedDates = DateUtil.calculate30Mins(date: Date(), round: true)
            let calbit = self.selectedEvent
            
            let destinationController = segue.destination as! CalbitDetailVC
            destinationController.calbit = calbit
            destinationController.delegate = self
            
            // Setup navbar (custom back button) & tabbar (hide)
            let startDateComponents = DateUtil.components(calbit.startDate)
            self.navigationItem.backBarButtonItem = UIBarButtonItem()
            self.navigationItem.backBarButtonItem?.title =
            "\(startDateComponents.day!) \(calbit.startDate.formatMMM())"
            
            destinationController.hidesBottomBarWhenPushed = true
            
        }
    }
    
    
}

extension WeekVC : JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNavbarTitle()
    }
    
}
