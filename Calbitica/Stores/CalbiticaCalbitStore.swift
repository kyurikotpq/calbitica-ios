//
//  CalbiticaCalbitStore
//  Calbitica
//
//  Created by Student on 17/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class CalbiticaCalbitStore {
    static let instance = CalbiticaCalbitStore()
    var calbits: [Calbit?]
    
    private init() {
        calbits = []
    }
    static func setCalbits(_ calbits: [Calbit?]) {
        instance.calbits = calbits
    }
    
    static func getCalbits() -> [Calbit?] {
        return instance.calbits
    }
    
    static func clearCalbits() {
        instance.calbits.removeAll()
    }
    
    // Helper function: convert calbit to calbit for JZ
    static func calbitToJZ(calbits: [Calbit?]) -> [CalbitForJZ] {
        return calbits.map({ (Calbit) -> CalbitForJZ in
            let start = Calbit!.legitAllDay ? Calbit!.start["date"] : Calbit?.start["dateTime"]
            let startDate = DateUtil.toDate(str: start!)
            
            let end = Calbit!.legitAllDay ? Calbit!.end["date"] : Calbit!.end["dateTime"]
            let endDate = DateUtil.toDate(str: end!)
            
            // Transform into a JZ-compliant calbit!
            return CalbitForJZ(id: Calbit!._id, isAllDay: Calbit!.allDay,
                               legitAllDay: Calbit!.legitAllDay, googleID: Calbit!.googleID,
                               calendarID: Calbit!.calendarID, summary: Calbit!.summary,
                               startDate: startDate!, endDate: endDate!,
                               location: Calbit!.location ?? nil,
                               description: Calbit!.description ?? nil,
                               completed: Calbit!.completed, reminders: Calbit!.reminders)
        })
    }
    
    static func selfPopulate(closure: @escaping ([Calbit?]) -> Void) {
        // Check if the JWT is ready
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"),
            jwt != ""
            else {
                // If the jwt is not ready, don't make a request.
                // wait for a while, then call this function
                // and attempt to make the request again.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.selfPopulate(closure: closure)
                }
                
                // Exit the getCalbitsAndRefresh function
                return
        }
        
        // Handle response from calbits
        // and render events as appropriate
        func handleCalbits(_ calbitResponse: CalbitsResponse) -> Void {
            self.clearCalbits()
            
            let calbits = calbitResponse.data
            print("calbits from respones")
            print(calbits)
            self.setCalbits(calbits)
            
            closure(calbits)
        }
        // JWT is ready - lets make the HTTP Request
        Calbitica.getCalbits(closure: handleCalbits)
    }
}
