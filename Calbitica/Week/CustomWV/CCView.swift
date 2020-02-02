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

// Contains the configurations for the custom week view
// All actions are handled by the delegate, aka WeekVC!
class CCView: JZBaseWeekView {
    // Registration of components' classes
    override func registerViewClasses() {
        super.registerViewClasses()
        
        // Register Row and Col header
        self.collectionView.register(DarkCCViewRowHeader.self, forSupplementaryViewOfKind: JZSupplementaryViewKinds.rowHeader, withReuseIdentifier: DarkCCViewRowHeader.className)
        
        self.collectionView.register(DarkCCViewColHeader.self, forSupplementaryViewOfKind: JZSupplementaryViewKinds.columnHeader, withReuseIdentifier: DarkCCViewColHeader.className)
        
        // Register our custom cell
        self.collectionView.register(UINib(nibName: "CalbitCell", bundle: nil), forCellWithReuseIdentifier: "CalbitCell")
    }
    
    // Adding the supplementary views (anything that is not a cell)
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == JZSupplementaryViewKinds.rowHeader {
            if let rowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DarkCCViewRowHeader.className, for: indexPath) as? DarkCCViewRowHeader {
                rowHeader.updateView(date: flowLayout.timeForRowHeader(at: indexPath))
                // disable time markings from being touched and selected
                return rowHeader
                
            }
            preconditionFailure("HourRowHeader should be casted")
        } else if kind == JZSupplementaryViewKinds.columnHeader {
            if let colHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DarkCCViewColHeader.className, for: indexPath) as? DarkCCViewColHeader {
                colHeader.updateView(date: flowLayout.dateForColumnHeader(at: indexPath))
                // day column chould create new all-day events
                return colHeader
            }
        }
        
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    // Configuring a single cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = "CalbitCell"
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CalbitCell,
            let event = getCurrentEvent(with: indexPath) as? CalbitForJZ {
            
            cell.configureCell(event: event)
            return cell
        }
        preconditionFailure("EventCell and DefaultEvent should be casted")
    }
    
    // MARK: - Interactions
    // When the event is tapped, show the detailed view...
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("WE selected something")
        if let selectedEvent = getCurrentEvent(with: indexPath) as? CalbitForJZ {
            self.selectedEvent = selectedEvent
            
            let weekVC = self.baseDelegate as! WeekVC
            weekVC.performSegue(withIdentifier: "detailCalbitSegue", sender: self)
        }
    }
 */
    
    
    
}
