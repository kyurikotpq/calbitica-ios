//
//  Calbitica.swift
//  Calbitica
//
//  Created by Student on 12/1/20.
//  Copyright © 2020 Calbitica. All rights reserved.
//

import Foundation
import HttpUtil

class Calbitica {
    let baseURL = "https://app.kyurikotpq.com/calbitica/api/"
    
    /**
    * Exchange auth code obtained locally for Calbitica JWTs
    */
    static func tokensFromAuthCode(_ code: String) {
        let url = baseURL + "auth/code"
        // let data = ()
        // HttpUtil.post(url, )
    }

    let calbitBaseURL = baseURL + "calbit/"
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

    let calendarBaseURL = baseURL + "calendar/"
    static func getCalendars() {
        let url = calendarBaseURL
        // HttpUtil.get(url)
    }
    static func importEvents() {
        let url = calendarBaseURL + "import"
        // HttpUtil.get(url)
    }
    static func changeCalSync(id: String, sync: Bool) {
        let url = calendarBaseURL + "sync/" + id + "?sync=" + sync

        // HttpUtil.get(url)
    }

    let habiticaBaseURL = baseURL + "h/"
    static func getHProfile() {
        let url = calendarBaseURL + "profile"

        // HttpUtil.get(url)
    }
    static func respondToQuest(accept: Bool, groupID: String) {
        let url = calendarBaseURL + "quest"

        // HttpUtil.post(url)
    }
    static func toggleSleep() {
        let url = calendarBaseURL + "sleep"

        // HttpUtil.get(url)
    }

    static func changeHabiticaAPIKey() {
        let url = calendarBaseURL + "settings/habitica"

        // HttpUtil.post(url)
    }
}
