//
//  WeekController.swift
//  Calbitica
//
//  Created by Student on 15/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class WeekVC: UIViewController {
    // Our Custom week view
    @IBOutlet weak var calendarWeekView: CCView!
    
    // variables
    static var today = Date()
    
    var calbits: [Calbit?] = []
    var pressedDates: (Date, Date) = (today, today)
    var creatingAllDay = false
    var selectedEvent = CalbitForJZ(id: "", isAllDay: false,
                                    legitAllDay: false, googleID: "",
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
        
        // Add tap-on-event-show-detail feature
        calendarWeekView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnCCView)))
        
        // Set navigation bar title to this week's date
        updateNavbarTitle()
        
        // Request events from Calbitica API (async)
        getCalbitsAndRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateNavbarTitle() {
        var datesInWeek: [Date] = calendarWeekView.getDatesInCurrentPage(isScrolling: false)
        let firstDate = datesInWeek[0]
        let lastDate = datesInWeek.last!
        self.navigationItem.title = DateUtil.buildNavbarTitle(firstDate: firstDate, lastDate: lastDate)
    }
    
    // Handle navigation bar actions
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        getCalbitsAndRefresh()
    }
    
    @IBAction func todayBtnPressed(_ sender: UIBarButtonItem) {
        // You need both of these functions if you want to jump
        // to today, but prevent today from being the first day of the week
        calendarWeekView.updateWeekView(to: WeekVC.today)
        calendarWeekView.updateFirstDayOfWeek(setDate: WeekVC.today, firstDayOfWeek: .Sunday)
    }
    
    @objc func tapOnCCView(sender: UITapGestureRecognizer){
        // Which element was tapped on exactly?
        let view = sender.view // the one attached to the gestures
        let loc = sender.location(in: view)
        let subview = view?.hitTest(loc, with: nil)
        let parentview = subview?.superview
        
        // disable time markings from triggering the segue
        let forbidden = (subview?.isMember(of: DarkCCViewRowHeader.self))!
            || (subview?.isMember(of: DarkCCViewAllDayCorner.self))!
            || (subview?.isMember(of: DarkCCViewCornerCell.self))!
        
        let isExistingEvent = (parentview?.isMember(of: CalbitCell.self))!
            || (subview?.isMember(of: CalbitCell.self))!
        
        print(subview?.superview)
        print(subview)
        
        
        do {
            // day column chould create new all-day events
            let newAllDay = (subview?.isMember(of: JZAllDayHeader.self))!
                || (subview?.isMember(of: DarkCCViewColHeader.self))!
                || (parentview?.isMember(of: DarkCCViewColHeader.self))!
            
            if let indexPath = calendarWeekView.collectionView?.indexPathForItem(at: sender.location(in: calendarWeekView.collectionView)) {
                if let selectedEvent = calendarWeekView.getCurrentEvent(with: indexPath) as? CalbitForJZ {
                    self.selectedEvent = selectedEvent
                    self.performSegue(withIdentifier: "detailCalbitSegue", sender: self)
                }
            } else if isExistingEvent {
                // Most likely an all-day event
                
                
            } else if (!forbidden) {
                let date = calendarWeekView.getDateForPoint(sender.location(in: calendarWeekView.collectionView))
                
                // Round of dates to the nearest 30mins
                // and calculate 30mins from there
                self.pressedDates = DateUtil.calculate30Mins(date: date, round: true)
                self.creatingAllDay = newAllDay
                self.performSegue(withIdentifier: "addCalbitSegue", sender: self)
                
            }
        } catch {
            
        }
        
    }
    
    func getCalbitsAndRefresh() {
        CalbiticaCalendarStore.selfPopulate()
        CalbiticaCalbitStore.selfPopulate(closure: refreshWeekView)
    }
    
    // re-load the week view
    func refreshWeekView(_ calbits: [Calbit?]) {
        self.calbits = calbits
        let calbitsForJZ = JZWeekViewHelper.getIntraEventsByDate(originalEvents: CalbiticaCalbitStore.calbitToJZ(calbits: calbits))
        
        calendarWeekView.forceReload(reloadEvents: calbitsForJZ)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addCalbitSegue") {
            // Adding new event
            let navController = segue.destination as! UINavigationController
            
            // We only have one VC for this navigation controller, so this works I guess...
            let destinationController = navController.topViewController as! SaveCalbitVC
            destinationController.addDelegate = self
            destinationController.isNewCalbit = true
            destinationController.pressedDates = self.pressedDates
            destinationController.calbit.legitAllDay = self.creatingAllDay
            
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
            self.pressedDates = DateUtil.calculate30Mins(date: Date(), round: true)
            let calbit = self.selectedEvent
            
            let destinationController = segue.destination as! CalbitDetailVC
            destinationController.calbit = calbit
            destinationController.delegate = self
            
            // Setup navbar (custom back button) & tabbar (hide)
            let startDateComponents = DateUtil.components(calbit.startDate)
            let title = "\(startDateComponents.day!) \(calbit.startDate.formatMMM())"
            let backBarButton = BackButtonItem(title)
            self.navigationItem.backBarButtonItem = backBarButton
            
            destinationController.hidesBottomBarWhenPushed = true
            
        }
        
    }
}

extension WeekVC : ReturnCalbitProtocol {
    // Remove deleted calbit from local array
    func removeDeletedCalbit(calbit: CalbitForJZ) {
        self.calbits.removeAll { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }
        refreshWeekView(self.calbits)
    }
    
    func updateCalbitCompletion(calbit: CalbitForJZ) {
        if let index = calbits.firstIndex(where: { (c: Calbit?) -> Bool in
            return c?._id == calbit.id
        }) {
            // update the local copy's completion status
            self.calbits[index]!.completed.status = calbit.completed.status
            
            // Reload the view!
            refreshWeekView(self.calbits)
        }
    }
    func saveCalbitFinished() {
        getCalbitsAndRefresh()
    }
}

extension WeekVC : JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNavbarTitle()
    }
    
}
