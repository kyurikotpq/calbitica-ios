//
//  CalbiticaCalendarStore.swift
//  Calbitica
//
//  Created by Student on 6/2/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class CalbiticaCalendarStore {
    static let instance = CalbiticaCalendarStore()
    var calendars: [CalbiticaCalendar]
    
    private init() {
        calendars = []
    }
    static func getFromGoogleID(_ googleID: String)
        -> (CalbiticaCalendar, Int) {
            if(googleID != "") {
                print(googleID)
                print(instance.calendars)
                let index = instance.calendars.firstIndex { (CalbiticaCalendar) -> Bool in
                    return CalbiticaCalendar.googleID == googleID
                }
                let cal = instance.calendars[index!]
                return (cal, index!)
            }
            return (instance.calendars.first!, 0)
    }
    
    static func setCalendars(_ calendars: [CalbiticaCalendar]) {
        instance.calendars = calendars
    }
    
    static func getCalendars() -> [CalbiticaCalendar] {
        return instance.calendars
    }
    
    static func clearCalendars() {
        instance.calendars.removeAll()
    }
    static func selfPopulate() {
        func handleCalList(calendars: [CalbiticaCalendar]) {
            self.setCalendars(calendars)
        }
        Calbitica.getCalendars(closure: handleCalList);
    }
}
