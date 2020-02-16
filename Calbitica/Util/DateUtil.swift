//
//  DateUtil.swift
//  Calbitica
//
//  Created by Student on 25/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

// Date-related helper functions
class DateUtil {
    static let calendar = Calendar(identifier: .gregorian)
    static let currentYear = calendar.dateComponents(in: .current, from: Date()).year!
    static let dateFormatter = DateFormatter()
    
    private init() {
        DateUtil.dateFormatter.dateStyle = .medium
    }
    
    static func components(_ date: Date) -> DateComponents {
        return calendar.dateComponents(in: .current, from: date)
    }
    
    // Return a date object from an ISO string
    // Since this needs to be called frequently and in a loop,
    // it is best to use a new DF instance so
    // that clashes won't happen with dateFormat "LLL"
    static func toDate(str: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = df.date(from: str)
        
        return date
    }
    
    static func roundTo30Mins(date: Date) -> DateComponents {
        var dateComponents = components(date)
        let roundToHalfMark = (dateComponents.minute! > 15 && dateComponents.minute! < 55)
        
        if(!roundToHalfMark && dateComponents.minute! >= 55) {
            dateComponents.hour = dateComponents.hour! + 1
        }
        dateComponents.minute = roundToHalfMark ? 30 : 0

        return dateComponents
    }
    static func calculate30Mins(date: Date, round: Bool) -> (Date, Date) {
        let startDateComponents = round ? DateUtil.roundTo30Mins(date: date)
        : components(date)
        
        var endDateComponents = round ? DateUtil.roundTo30Mins(date: date)
        : components(date)
        endDateComponents.minute = endDateComponents.minute! + 30
        
        return (startDateComponents.date!, endDateComponents.date!)
    }
    
    // Build a to-from string for event detail screen
    static func buildToFromString(startDate: Date, endDate: Date) -> (String, String) {
        let startDateComponents = components(startDate)
        let endDateComponents = components(endDate)
        
        var startString = "", endString = ""
        
        let startH = startDateComponents.hour!,
            startHours = startH < 10 ? "0\(startH)" : "\(startH)",
            endH = endDateComponents.hour!,
            endHours = endH < 10 ? "0\(endH)" : "\(endH)",
        
            startMin = startDateComponents.minute!,
            startMinutes = startMin < 10 ? "0\(startMin)" : "\(startMin)",
            endMin = endDateComponents.minute!,
            endMinutes = endMin < 10 ? "0\(endMin)" : "\(endMin)"
        
        // check if it's happening across days
        // if so, format the string accordingly
        if(startDateComponents.day != endDateComponents.day) {
            
            startString = "from \(startHours):\(startMinutes) on "
            + startDate.ddMMMYYYY(false)
            endString = "to \(endHours):\(endMinutes) on "
            + endDate.ddMMMYYYY(false)
        } else {
            // else just make it "Saturday, 01 Jan 2020" / "from 01:00 to 02:00"
            
            startString = "\(startDate.getDayOfWeek()), " + startDate.ddMMMYYYY(false)
            endString = "from \(startHours):\(startMinutes) "
            + "to \(endHours):\(endMinutes)"
        }
        
        return (startString, endString)
    }
    
    // format a string for the navigation bar (month only)
    static func buildNavbarTitle(firstDate: Date, lastDate: Date) -> String {
        var title = ""
        dateFormatter.dateFormat = "LLL"
        
        let firstDateComponents = components(firstDate)
        let lastDateComponents = components(lastDate)
        
        let isSameYear = (firstDateComponents.year == lastDateComponents.year)
        
        // If week is in the same month and year, just do a MMM YYYY
        if((firstDateComponents.month == lastDateComponents.month)
            && isSameYear) {
            let yearString = calendar.dateComponents(in: .current, from: firstDate).year!
           
            title = "\(dateFormatter.string(for: lastDate)!)"
            title += " \(yearString)"
            
        } else if((firstDateComponents.month != lastDateComponents.month)) {
            // If week is different months but same year, just do a MMM - MMM YYY
            var firstMMM = "\(dateFormatter.string(for: firstDate)!)"
            var lastMMM = "\(dateFormatter.string(for: lastDate)!)"
            
            if(!isSameYear) {
                firstMMM += " \(firstDateComponents.year!)"
                lastMMM += " \(lastDateComponents.year!)"
                
                title = "\(firstMMM) - \(lastMMM)"
            } else {
                // add the year at the back if it's NOT the current year
                title = "\(firstMMM) - \(lastMMM)"
                let yearString = calendar.dateComponents(in: .current, from: firstDate).year!
                title += " \(yearString)"
            }
        }
        
        return title
    }
}

// Extensions for Date objects
extension Date {
    // Build a "01 Jan 2020" kind of string
    func ddMMMYYYY(_ withTime: Bool) -> String {
        let formatter = DateUtil.dateFormatter
        var formatString = "dd LLL yyyy"
        
        if(withTime) {
            formatString += " HH:mm"
        }
        
        formatter.dateFormat = formatString
        return formatter.string(from: self)
    }
    
    // format date to other string formats
    // other than the ones provided
    func otherFormats(_ format: String) -> String {
        let formatter = DateUtil.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // Return a date object from an ISO string
    func toISOString() -> String {
        let formatter = DateUtil.dateFormatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateStr = formatter.string(from: self)
        
        return dateStr
    }
    
    func formatMMM() -> String {
        let formatter = DateUtil.dateFormatter
        formatter.dateFormat = "LLL"
        return formatter.string(from: self)
    }
    
    func getDayOfWeek() -> DayOfWeek {
        let weekDayNum = Calendar.current.component(.weekday, from: self)
        let weekDay = DayOfWeek(rawValue: weekDayNum)!
        return weekDay
    }
    
}

public enum DayOfWeek: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}
