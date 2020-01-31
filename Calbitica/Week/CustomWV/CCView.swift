//
//  CCView.swift
//  Calbitica
//
//  Created by Student on 26/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//
//  Includes overrides for RowHeader and ColumnHeader
//

import UIKit
import JZCalendarWeekView

class CCView: JZBaseWeekView {
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(DarkCCViewRowHeader.self, forSupplementaryViewOfKind: JZSupplementaryViewKinds.rowHeader, withReuseIdentifier: DarkCCViewRowHeader.className)
        
        self.collectionView.register(DarkCCViewColHeader.self, forSupplementaryViewOfKind: JZSupplementaryViewKinds.columnHeader, withReuseIdentifier: DarkCCViewColHeader.className)
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == JZSupplementaryViewKinds.rowHeader {
            if let rowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DarkCCViewRowHeader.className, for: indexPath) as? DarkCCViewRowHeader {
                rowHeader.updateView(date: flowLayout.timeForRowHeader(at: indexPath))
                return rowHeader
                
            }
            preconditionFailure("HourRowHeader should be casted")
        } else if kind == JZSupplementaryViewKinds.columnHeader {
            if let colHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DarkCCViewColHeader.className, for: indexPath) as? DarkCCViewColHeader {
                colHeader.updateView(date: flowLayout.dateForColumnHeader(at: indexPath))
                return colHeader
            }
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

/*
class CCViewHelper : JZWeekViewHelper {
    func getIntraEventsByDate<CalbitForJZ: JZBaseEvent>(originalEvents: [Calbit]) -> [Date: [CalbitForJZ]] {
        var resultEvents = [Date: [CalbitForJZ]]()
        
        for event in originalEvents {
            let startDateStartDay = event.allDay ? event.start["date"] : event.start["dateTime"]
            
            // get days from both startOfDay, otherwise 22:00 - 01:00 case will get 0 daysBetween result
            let daysBetween = Date.daysBetween(start: startDateStartDay, end: event.endDate, ignoreHours: true)
            if daysBetween == 0 {
                if resultEvents[startDateStartDay] == nil {
                    resultEvents[startDateStartDay] = [CalbitForJZ]()
                }
                if let copiedEvent = event.copy() as? CalbitForJZ {
                    resultEvents[startDateStartDay]?.append(copiedEvent)
                }
            } else {
                // Cross days
                for day in 0...daysBetween {
                    let currentStartDate = startDateStartDay.add(component: .day, value: day)
                    if resultEvents[currentStartDate] == nil {
                        resultEvents[currentStartDate] = [CalbitForJZ]()
                    }
                    guard let newEvent = event.copy() as? CalbitForJZ else { return resultEvents }
                    if day == 0 {
                        newEvent.intraEndDate = startDateStartDay.endOfDay
                    } else if day == daysBetween {
                        newEvent.intraStartDate = currentStartDate
                    } else {
                        newEvent.intraStartDate = currentStartDate.startOfDay
                        newEvent.intraEndDate = currentStartDate.endOfDay
                    }
                    resultEvents[currentStartDate]?.append(newEvent)
                }
            }
        }
        return resultEvents
    }
}
*/
