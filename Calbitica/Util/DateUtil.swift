//
//  DateUtil.swift
//  Calbitica
//
//  Created by Student on 25/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class DateUtil {
    static let instance = DateUtil()
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    
    private init() {
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "LLL"
    }
    
    
    // format a date for the navigation bar
    static func buildNavbarTitle(firstDate: Date, lastDate: Date) -> String {
        var title = ""
        
        let firstDateComponents = instance.calendar.dateComponents(in: .current, from: firstDate)
        let lastDateComponents = instance.calendar.dateComponents(in: .current, from: lastDate)
        
        let currentYear = instance.calendar.dateComponents(in: .current, from: Date()).year!
        let isSameYear = (firstDateComponents.year == lastDateComponents.year)
        let isCurrentYear = (currentYear == firstDateComponents.year)
                        && (currentYear == lastDateComponents.year)
        
        // If week is in the same month and year, just do a DD - DD MMM
        if((firstDateComponents.month == lastDateComponents.month)
            && isSameYear) {
            title = "\(firstDateComponents.day!) - \(lastDateComponents.day!) "
            title += instance.dateFormatter.string(for: lastDate)!
            
            // add the year at the back if it's NOT the current year
            if(!isCurrentYear) {
                let yearString = instance.calendar.dateComponents(in: .current, from: firstDate).year!
                title += "\(yearString)"
            }
        } else if((firstDateComponents.month != lastDateComponents.month)) {
            // If week is different months but same year, just do a DD MMM - DD MMM
            var firstDDMMM = "\(firstDateComponents.day!) \(instance.dateFormatter.string(for: firstDate)!)"
            var lastDDMMM = "\(lastDateComponents.day!) \(instance.dateFormatter.string(for: lastDate)!)"
            
            if(!isSameYear) {
                firstDDMMM += " \(firstDateComponents.year!)"
                lastDDMMM += " \(lastDateComponents.year!)"
                
                title = "\(firstDDMMM) - \(lastDDMMM)"
            } else if(!isCurrentYear) {
                // add the year at the back if it's not the current year
                let yearString = instance.calendar.dateComponents(in: .current, from: firstDate).year!
                title += "\(yearString)"
            }
        }
        
        return title
    }
}
