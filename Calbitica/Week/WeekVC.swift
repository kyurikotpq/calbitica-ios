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
    @IBOutlet weak var calendarWeekView: JZBaseWeekView!
    
    let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // setup calendar
        // JZColumnHeader.
//        JZRowHeader.tint
        
        calendarWeekView.collectionView.tintColor = .white
        calendarWeekView.collectionView.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        calendarWeekView.setupCalendar(numOfDays: 7,
                                       setDate: today,
                                       allEvents: JZWeekViewHelper.getIntraEventsByDate(originalEvents: []),
                                       scrollType: .pageScroll,
                                       firstDayOfWeek: .Sunday)
        
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        // Set navigation bar title to this week's date
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
    //
//    @objc func goToThisWeek() {
//
//    }
//
//    @objc func refreshBtnPressed() {
//        refreshWeek()
//    }
//    @objc func addBtnPressed() {
//
//    }
    
    func refreshWeek() {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
