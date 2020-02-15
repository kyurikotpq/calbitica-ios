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
    
    var legitAllDay: Bool
    var allDay: Bool
    var start: [String: String]
    var end: [String: String]
    
    var completed: CalbitCompleted
    var reminders: [String?]?
}

// Declare this outside the parent struct
// for ease of use in VCs later
struct CalbitCompleted : Codable {
    var status: Bool
    var date: String?
}
