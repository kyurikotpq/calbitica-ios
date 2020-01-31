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
    
    @IBOutlet weak var calendarWeekView: CCView!
    
    let today = Date()
    var originalEvents = CalbiticaCalbits(jwt: "", data: [])
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // setup calendar
        calendarWeekView.collectionView.tintColor = .white
        calendarWeekView.collectionView.backgroundColor = .black
        
        calendarWeekView.setupCalendar(numOfDays: 7,
                                       setDate: today,
                                       allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: []),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Sunday)
        calendarWeekView.baseDelegate = self
        
        // setup navbar
        setupNavbar()
        
        // Request events from Calbitica API (async)
        // Render events from API
        print("I AM IN WEEK")
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
    }
    @IBAction func todayBtnPressed(_ sender: UIBarButtonItem) {
        // Somehow, you need both of these functions.
        // Will research soon as to why...
        calendarWeekView.updateWeekView(to: today)
        calendarWeekView.updateFirstDayOfWeek(setDate: today, firstDayOfWeek: .Sunday)
    }
    
    func refreshWeek() {
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if(segue.identifier == "addCalbitSegue") {
            // Adding new event
            let destinationController = segue.destination as! SaveCalbitVC
            destinationController.calbitTitle = "Add New Event"
        } else if(segue.identifier == "detailCalbitSegue") {
            // viewing details of event
        }
     }
    
    
}

extension WeekVC : JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        updateNavbarTitle()
    }
    
}
