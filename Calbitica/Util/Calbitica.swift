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
        let data = ["code": code] // data to pass in POST
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: response)
                closure(decodedUser.jwt)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
    

    static let calbitBaseURL = baseURL + "calbit/"
    static func getCalbits(closure: @escaping (CalbitsResponse) -> Void) {
        let url = calbitBaseURL
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let calbits = try JSONDecoder().decode(CalbitsResponse.self, from: response)
                
                if let jwt = calbits.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                closure(calbits)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        // Make the HTTP Request
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    static func createCalbit(data: [String: Any], closure: @escaping (Data) -> Void) {
        let url = calbitBaseURL
        HttpUtil.post(url: url, data: data, closure: closure)
    }
    static func completeCalbit(_ id: String, status: Bool) {
        let url = calbitBaseURL + id + "/complete"
        let data = ["status": status]
        HttpUtil.put(url: url, data: data, closure: { _ in })
    }
    static func updateCalbit(_ id: String, data: [String: Any], closure: @escaping (Data) -> Void) {
        let url = calbitBaseURL + id
        HttpUtil.put(url: url, data: data, closure: closure)
    }
    static func deleteCalbit(_ id: String) {
        let url = calbitBaseURL + id
        
        HttpUtil.delete(url: url, closure: { })
    }

    static let calendarBaseURL = baseURL + "cal/"
    static func getCalendars(closure: @escaping ([CalbiticaCalendar]) -> Void) {
        let url = calendarBaseURL
        
        func httpFinishClosure(response: Data) {
            do {
                let calendars = try JSONDecoder().decode(CalendarsResponse.self, from: response)
                
                if let jwt = calendars.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                closure(calendars.data)
            } catch {
                // JSONSerialization.dec
                print("JSON error: \(error.localizedDescription)")
            }
        }
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    static func importEvents() {
        let url = calendarBaseURL + "import"
        // HttpUtil.get(url)
    }
    static func changeCalSync(id: String, sync: Bool, closure: @escaping (Data) -> Void) {
        let syncStr = (sync) ? "true" : "false"
        let url = calendarBaseURL + "sync/" + id + "?sync=" + syncStr

        // Make the HTTP Request
        HttpUtil.get(url: url, closure: closure)
    }

    static let habiticaBaseURL = baseURL + "h/"
    static func getHProfile(closure: @escaping (Profile) -> Void) {
        let url = habiticaBaseURL + "profile"
        
        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedProfile = try JSONDecoder().decode(ProfileResponse.self, from: response)
                
                // handle jwt
                if let jwt = decodedProfile.jwt {
                    AuthController.handleJWTClosure(jwt: jwt)
                }
                
                closure(decodedProfile.data)
            } catch {
                //                JSONSerialization.dec
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.get(url: url, closure: httpFinishClosure)
    }
    static func respondToQuest(accept: Bool, groupID: String) {
        let url = habiticaBaseURL + "quest"

        // HttpUtil.post(url)
    }
//    static func toggleSleep(closure: @escaping (String) -> Void) -> Bool {
//        let url = habiticaBaseURL + "sleep"
//
//        func httpFinishClosure(response: Data) {
//            do {
//                // Decode message
//                let decodedMessage = try JSONDecoder().decode(Message.self, from: response)
//                closure(decodedMessage)
//            } catch {
//                //                JSONSerialization.dec
//                print("JSON error: \(error.localizedDescription)")
//            }
//        }
//        
//        HttpUtil.get(url: url, closure: httpFinishClosure)
//    }

    static func changeHabiticaAPIKey(data: [String: String], closure: @escaping (String) -> Void) {
        let url = baseURL + "settings/habitica"

        // When the response from API is returned,
        // run this function
        func httpFinishClosure(response: Data) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: response)
                closure(decodedUser.jwt)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        // Make the HTTP Request
        HttpUtil.post(url: url, data: data, closure: httpFinishClosure)
    }
}
