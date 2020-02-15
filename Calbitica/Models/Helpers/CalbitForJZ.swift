//
//  CalbitForJZ.swift
//  Calbitica
//
//  Created by Student on 7/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation
import JZCalendarWeekView

// Models the API data for the JZCalendar
class CalbitForJZ : JZAllDayEvent {
    var calendarID: String // MongoDB Calendar ID
    var googleID: String // Google Event ID, can be null - only exists on Habitica [not supported yet]
    
    var legitAllDay: Bool // Whether it's a all-day event in Google Calendar or just span across many days nia
    var summary: String // Title
    var calbitDescription: String? // 'description' is a property from the parent
    var location: String?
    
    var completed: CalbitCompleted
    var reminders: [String?]?
    
    // id will be the mongoDB ID!
    init(id: String, isAllDay: Bool, legitAllDay: Bool, googleID: String, calendarID: String,
         summary: String, startDate: Date, endDate: Date, location: String?,
         description: String?, completed: CalbitCompleted,
         reminders: [String?]?) {
        
        // Initialise own variables first!
        self.legitAllDay = legitAllDay
        self.googleID = googleID
        self.calendarID = calendarID
        self.summary = summary
        self.completed = completed
        
        self.location = location
        self.calbitDescription = description
        self.reminders = reminders
        
        super.init(id: id, startDate: startDate, endDate: endDate, isAllDay: isAllDay)
        
    }
    
    override func copy(with zone: NSZone?) -> Any {
        return CalbitForJZ(id: id, isAllDay: isAllDay, legitAllDay: legitAllDay, googleID: googleID, calendarID: calendarID, summary: summary, startDate: startDate, endDate: endDate, location: location ?? nil, description: calbitDescription ?? nil, completed: completed, reminders: reminders)
    }
}
