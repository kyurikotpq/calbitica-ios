//
//  Calbitica.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation

class Calbitica {
    static let baseURL = "https://app.kyurikotpq.com/calbitica/api/"
    
    /**
    * Exchange auth code obtained locally for Calbitica JWTs
    */
    static func tokensFromAuthCode(_ code: String, closure: @escaping (String) -> Void) {
        let url = baseURL + "auth/code"
        let data = ["code": code]
        
        func httpFinishClosure(response: Data) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: response)
                closure(decodedUser.jwt)
            } catch {
//                JSONSerialization.dec
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
    

    static let calbitBaseURL = baseURL + "calbit/"
    static func getCalbits() {
        let url = calbitBaseURL
        // HttpUtil.get(url)
    }
    static func createCalbit() {
        let url = calbitBaseURL
        // HttpUtil.post(url)
    }
    static func completeCalbit(_ id: String) {
        let url = calbitBaseURL + id + "/complete"
        // HttpUtil.put(url)
    }
    static func updateCalbit(_ id: String) {
        let url = calbitBaseURL + id
        // HttpUtil.put(url)
    }
    static func deleteCalbit(_ id: String) {
        let url = calbitBaseURL + id
        // HttpUtil.delete(url)
    }

    static let calendarBaseURL = baseURL + "calendar/"
    static func getCalendars() {
        let url = calendarBaseURL
        // HttpUtil.get(url)
    }
    static func importEvents() {
        let url = calendarBaseURL + "import"
        // HttpUtil.get(url)
    }
    static func changeCalSync(id: String, sync: Bool) {
        let syncStr = (sync) ? "true" : "false"
        let url = calendarBaseURL + "sync/" + id + "?sync=" + syncStr

        // HttpUtil.get(url)
    }

    static let habiticaBaseURL = baseURL + "h/"
    static func getHProfile() {
        let url = habiticaBaseURL + "profile"

        // HttpUtil.get(url)
    }
    static func respondToQuest(accept: Bool, groupID: String) {
        let url = habiticaBaseURL + "quest"

        // HttpUtil.post(url)
    }
    static func toggleSleep() {
        let url = habiticaBaseURL + "sleep"

        // HttpUtil.get(url)
    }

    static func changeHabiticaAPIKey() {
        let url = habiticaBaseURL + "settings/habitica"

//         HttpUtil.post(url)
    }
}
