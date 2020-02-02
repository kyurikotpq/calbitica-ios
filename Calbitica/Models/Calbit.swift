//
//  Calbit.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class Calbit : Codable {
    var `_id`: String // MongoDB ID
    var calendarID: String // MongoDB Calendar ID
    var googleID: String // Google Event ID, can be null - only exists on Habitica [not supported yet]
    
    // var habiticaType: String // Habit, Task, Daily
    var isDump: Bool // true if brain dump or not assigned date time yet
    
    var summary: String // Title
    var description: String? // description
    var location: String?
    
    var allDay: Bool
    var start: [String: String]
    var end: [String: String]
    
    var completed: CalbitCompleted
    var reminders: [String]?
}

struct CalbitCompleted : Codable {
    var status: Bool
    var date: String?
}

// Models the API data for the JZCalendar
class CalbitForJZ : JZAllDayEvent {
    var calendarID: String // MongoDB Calendar ID
    var googleID: String // Google Event ID, can be null - only exists on Habitica [not supported yet]
    
    var summary: String // Title
    var calbitDescription: String? // 'description' is a property from the parent
    var location: String?
    
    var completed: CalbitCompleted
    var reminders: [String]?
    
    // id will be the mongoDB ID!
    init(id: String, isAllDay: Bool, googleID: String, calendarID: String,
         summary: String, startDate: Date, endDate: Date, location: String?,
         description: String?, completed: CalbitCompleted,
         reminders: [String]?) {
        
        // Initialise own variables first!
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
        return CalbitForJZ(id: id, isAllDay: isAllDay, googleID: googleID, calendarID: calendarID, summary: summary, startDate: startDate, endDate: endDate, location: location ?? nil, description: calbitDescription ?? nil, completed: completed, reminders: reminders)
    }
}
